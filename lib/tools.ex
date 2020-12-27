defmodule Cannes.Tools do
  @moduledoc """
  `Cannes.Tools` facilitates a usefull wrapper for the python library called `cantool`.
  """
  use Export.Python

  @python_dir "lib/python"
  @python_module "cantool"

  @doc """
  Calls the given function with args from the given Python file.
  """
  def python_call(file, function, args \\ []) do
    {:ok, py} = Python.start(python_path: Path.expand(@python_dir))
    Python.call(py, file, function, args)
  end

  @doc """
  Decode given signal data data as a message of given frame id or name frame_id_or_name. Returns a dictionary of signal name-value entries.

  If decode_choices is `false` scaled values are not converted to choice strings (if available).

  If scaling is `false` no scaling of signals is performed.

  ## Example
      iex> Cannes.Tools.decode_message(2024, <<0x04, 0x41, 0x0C, 0x02, 0x6A, 0x00, 0x00, 0x00>>)
      %{
        'ParameterID_Service01' => 'S1_PID_0C_EngineRPM',
        'S1_PID_0C_EngineRPM' => 154.5,
        'length' => 4,
        'response' => 4,
        'service' => 'Show current data '
      }
  """
  def decode_message(arbitration_id, data, decode_choices \\ true, scaling \\ true) do
    python_call(@python_module, "decode_message", [arbitration_id, data, decode_choices, scaling])
  end

  @doc """
  Encode given signal data data as a message of given frame id or name frame_id_or_name. data is a dictionary of signal name-value entries.

  If scaling is `false` no scaling of signals is performed.

  If padding is `true` unused bits are encoded as 1.

  If strict is `true` all signal values must be within their allowed ranges, or an exception is raised.

  ## Example
      iex> Cannes.Tools.encode_message(2024, %{"ParameterID_Service01" => "S1_PID_0C_EngineRPM", "S1_PID_0C_EngineRPM" => 154.5, "length" => 4, "response" => 4, "service" => "Show current data "})
      <<4, 65, 12, 2, 106, 0, 0, 0>>
  """
  def encode_message(frame_id_or_name, data, scaling \\ true, padding \\ false, strict \\ true) do
    python_call(@python_module, "encode_message", [
      frame_id_or_name,
      data |> Jason.encode!(),
      scaling,
      padding,
      strict
    ])
  end
end
