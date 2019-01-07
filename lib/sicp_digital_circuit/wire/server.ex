defmodule SicpDigitalCircuit.Wire.Server do
  alias SicpDigitalCircuit.Wire
  use GenServer

  def start_link(args \\ %Wire{}) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(args) do
    {:ok, args}
  end

  def handle_cast({:set_signal, signal}, _from, %{signal: signal} = state) do
    {:reply, :ok, state}
  end

  def handle_cast({:set_signal, signal}, _from, state) do
    new_state = %{state | signal: signal}
    Enum.each(state.actions, &(&1.(new_state)))
    {:noreply, new_state}
  end

  def handle_cast({:add_action, action}, _from, state) do
    action.()
    {:noreply, %{state | actions: [action | state.actions]}}
  end

  def handle_call(:get_signal, _from, state) do
    {:reply, state.signal, state}
  end
end
