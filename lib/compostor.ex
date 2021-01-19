defmodule Cannes.Compostor do
  @moduledoc """
    This module is the counterpart to the `Cannes.Dumper`.
    With the help of the included functions it is possible to send CAN messages
  """

  @spec send(any, any, any) :: {any, any}
  def send(interface, identifier, data) do
    %Porcelain.Result{out: output, status: status} =
      Porcelain.shell("cansend #{interface} #{identifier}##{data}")

    {status, output}
  end
end
