defmodule Cannes.Mock do
  @moduledoc """
  Provides some usefull functions for simulating can messages.

    TODO:
    - More advanced mocking for can messages
  """

  @doc """
  Returns an infinite stream of formatted can messages.
  Currently we use a simple logging file as blueprints for the messages

  ## Example
      iex(2)> stream = Cannes.Mock.file_stream()
      #Function<63.104660160/2 in Stream.unfold/2>
      iex(3)> Enum.take(stream, 5)
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
  """
  def file_stream() do
    {:ok, contents} = File.read("./data/can_dump.log")

    contents
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> Cannes.Dumper.format_candump_string(line) end)
    |> Stream.cycle()
  end
end
