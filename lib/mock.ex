defmodule Cannes.Mock do
  @moduledoc """
  Provides some usefull functions for simulating can messages.

    TODO:
    - More advanced mocking for can messages
  """

  @spec file_stream(any) ::
          ({:cont, any} | {:halt, any} | {:suspend, any}, any ->
             {:done, any} | {:halted, any} | {:suspended, any, (any -> any)})
  @doc """
  Returns an infinite stream of formatted can messages.
  Currently we use a simple logging file as blueprints for the messages

  ## Examples

      iex> stream = Cannes.Mock.file_stream()
      #Function<63.104660160/2 in Stream.unfold/2>
      iex> Enum.take(stream, 5)
      [
        %{
          data: <<0, 0, 0, 0, 0, 208, 50, 0>>,
          identifier: <<1, 102>>,
          interface: "can0",
          timestamp: 1398128223.803317
        },
        %{
          data: <<0, 0, 0, 0, 0, 0, 0, 0>>,
          identifier: <<1, 88>>,
          interface: "can0",
          timestamp: 1398128223.804583
        },
        %{
          data: <<0, 0, 0, 5, 80, 1, 8, 0>>,
          identifier: <<1, 97>>,
          interface: "can0",
          timestamp: 1398128223.804828
        },
        %{
          data: <<0, 0, 1, 0, 144, 161, 65, 0>>,
          identifier: <<1, 145>>,
          interface: "can0",
          timestamp: 1398128223.805039
        },
        %{
          data: <<0, 0, 0, 0, 0, 0, 0, 0>>,
          identifier: <<1, 142>>,
          interface: "can0",
          timestamp: 1398128223.80535
        }
      ]

      iex> Cannes.Mock.file_stream(true) |> Enum.take(2)
      [
        %{
          data: <<0, 0, 0, 0, 208, 50, 0, 9>>,
          identifier: <<1, 102>>,
          interface: "can0",
          timestamp: 1611064041
        },
        %{
          data: <<0, 0, 0, 0, 0, 0, 0, 10>>,
          identifier: <<1, 88>>,
          interface: "can0",
          timestamp: 1611064041
        }
      ]

  """
  def file_stream(unix_timestamp? \\ false) do
    {:ok, contents} = File.read("./data/can_dump.log")

    contents
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> Cannes.Dumper.format_candump_string(line, unix_timestamp?) end)
    |> Stream.cycle()
  end
end
