defmodule SicpDigitalCircuit.Inverter do
  alias SicpDigitalCircuit.{Agenda, Wire}

  def apply(input, output) do
    invert_input = fn(state) ->
      new_signal = state.signal

      Agenda.after_delay(:inverter, fn ->
        Wire.set_signal(output, new_signal)
      end)
    end

    Wire.add_action(input, invert_input)
  end
end
