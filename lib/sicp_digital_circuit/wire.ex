defmodule SicpDigitalCircuit.Wire do
  defstruct [
    :signal,
    actions: []
  ]

  alias SicpDigitalCircuit.Wire.Server

  def new(signal \\ false, actions \\ []) do
    %__MODULE__{signal: signal, actions: actions}
    |> SicpDigitalCircuit.Wire.Server.start_link()
  end

  @spec set_signal(Server.t(), boolean()) :: :ok
  def set_signal(wire, signal) do
    GenServer.cast(wire, {:set_signal, signal})
  end

  @spec add_action(Server.t(), function()) :: :ok
  def add_action(wire, action) do
    GenServer.cast(wire, {:add_action, action})
  end

  @spec get_signal(Server.t()) :: boolean()
  def get_signal(wire) do
    GenServer.call(wire, :get_signal)
  end
end
