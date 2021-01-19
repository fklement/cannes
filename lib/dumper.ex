defmodule Cannes.Dumper do
  @moduledoc """
  This module is for communicating with linux can sockets over candump.

    TODO:
    - Add logic to mount a can interface
    - Test if desired interface is reacable
    - Test if candump is available
    - Pass options to candump
  """
  alias Porcelain.Process, as: Proc

  @doc """
  Spawns a candump process on the given interface.

  ## Example
      iex> Cannes.Dumper.start("vcan0")
      %Porcelain.Process{
        err: nil,
        out: #Function<63.104660160/2 in Stream.unfold/2>,
        pid: #PID<0.212.0>
      }
  """
  @spec start(binary) :: Porcelain.Process.t()
  def start(interface) when is_binary(interface) do
    proc = Porcelain.spawn("candump", ["-L", interface], out: :stream)

    case proc do
      {:error, message} -> raise message
      _ -> proc
    end
  end

  @doc """
  Stops a running candump process carefully.

  ## Example
      proc = Cannes.Dumper.stop(proc)
      true

  """
  @spec stop(Porcelain.Process.t()) :: true
  def stop(dumper_process) do
    Proc.stop(dumper_process)
  end

  @doc """
  Check if the candump process is still running.
  """
  @spec alive?(Porcelain.Process.t()) :: boolean
  def alive?(dumper_process) do
    Proc.alive?(dumper_process)
  end

  @doc """
  Returns a stream of formatted can messages.

  ## Example
    iex> Cannes.Dumper.get_formatted_stream(proc)
    #Stream<[
    enum: #Function<63.104660160/2 in Stream.unfold/2>,
    funs: [#Function<51.104660160/1 in Stream.reject/2>,
    #Function<38.104660160/1 in Stream.each/2>]
    ]>
  """
  @spec get_formatted_stream(Porcelain.Process.t()) :: Stream.t()
  def get_formatted_stream(dumper_process) do
    get_stream(dumper_process)
    |> Stream.each(fn item ->
      format_candump_string(item)
    end)
  end

  @spec get_stream(Porcelain.Process.t()) ::
          (any, any -> {:halted, any} | {:suspended, any, (any -> any)})
  def get_stream(%Proc{out: outstream}) do
    outstream
    |> Stream.flat_map(&String.split(&1, "\n", trim: true))
  end

  @doc """
  Parses the given candump string in the candump log format into a map.

  ## Example
      iex> Cannes.Dumper.format_candump_string("(1398128227.045337) can0 133#0000000098")
      %{
        data: <<0, 0, 0, 0, 0, 0, 0, 9>>,
        identifier: <<1, 51>>,
        interface: "can0",
        timestamp: 1398128227.045337
      }
  """
  @spec format_candump_string(binary, any) :: %{
          data: binary,
          identifier: binary,
          interface: any,
          timestamp: number
        }
  def format_candump_string(dump_string, unix_timestamp? \\ false) do
    message = dump_string |> String.split(" ")
    payload = String.split(Enum.at(message, 2), "#")

    timestamp =
      case unix_timestamp? do
        true -> DateTime.utc_now() |> DateTime.to_unix()
        _ -> String.slice(Enum.at(message, 0), 1..-2) |> String.to_float()
      end

    %{
      timestamp: timestamp,
      interface: Enum.at(message, 1),
      identifier: Enum.at(payload, 0) |> String.pad_leading(4, "0") |> Base.decode16!(),
      data: Enum.at(payload, 1) |> String.pad_leading(16, "0") |> Base.decode16!()
    }
  end
end
