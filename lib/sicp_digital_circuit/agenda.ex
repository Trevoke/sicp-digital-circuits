defmodule SicpDigitalCircuit.Agenda do
  alias SicpDigitalCircuit.Agenda.Server

  def new do
    Server.start_link()
  end

  def after_delay(type, function, agenda \\ Server) do
    add_to_agenda(agenda, type, function)
  end

  def empty?(agenda), do: GenServer.call(agenda, :empty?)

  def first_item(agenda), do: GenServer.call(agenda, :first_item)

  def add_to_agenda(agenda, type, action) do
    GenServer.call(agenda, {:add_to_agenda, type, action})
  end
end
