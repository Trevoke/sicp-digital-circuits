defmodule SicpDigitalCircuit.Agenda.Server do
  use GenServer

  def start_link(args \\ %{}) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(args) do
    defaults = %{
      sim_time: 0,
      delay_table: %{
        inverter: 2,
        and_gate: 3,
        or_gate: 5
      },
      schedule: %{}
    }

    {:ok, Map.merge(defaults, args)}
  end

  def handle_call({:add_to_agenda, type, action}, _from, state) do
    time = state.delay_table[type] + state.sim_time
    new_schedule = add_to_schedule(state.schedule, time, action)
    {:reply, :ok, %{state | schedule: new_schedule}}
  end

  def handle_call(:empty?, _from, state) do
    {:reply, Enum.empty?(state.schedule), state}
  end

  def handle_call(:first_item, _from, state) do
    if Enum.empty?(state.schedule) do
      {:reply, {:error, "agenda is empty"}, state}
    else
      next_time_to_run =
        state.schedule
        |> Map.keys()
        |> Enum.min()

      action =
        state.schedule
        |> Map.get(next_time_to_run)
        |> :queue.get()

      {:reply, {:ok, action}, %{state | sim_time: next_time_to_run}}
    end
  end

  def handle_call(:remove_first_agenda_item, _from, state) do
    schedule =
      state.schedule
      |> Map.update!(state.sim_time, &:queue.out(&1))

    empty_queue? =
      Map.get(schedule, state.sim_time)
      |> :queue.is_empty

    schedule = if empty_queue? do
      Map.delete(schedule, state.sim_time)
    else
      schedule
    end

    {:reply, :ok, %{state | schedule: schedule}}
  end

  defp add_to_schedule(schedule, time, action) do
    Map.update(
      schedule,
      time,
      :queue.from_list([action]),
      &:queue.in(&1, action)
    )
  end
end
