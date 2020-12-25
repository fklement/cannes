defmodule Cannes do
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

  If decode_choices is False scaled values are not converted to choice strings (if available).

  If scaling is False no scaling of signals is performed.

  ## Example
      iex> Cannes.decode_message(2024, <<0x04, 0x41, 0x0C, 0x02, 0x6A, 0x00, 0x00, 0x00>>)
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
end
