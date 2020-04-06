defmodule NetworkLed.Blinker do
  use GenServer

  @moduledoc """
  Simple GenServer to control GPIO #18
  """

  require Logger
  alias Nerves.Leds

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(_state) do
    led_on()
    state = :off
    Logger.info("In INIT: Disabling LED")
    Process.send_after(self(), state, 2_000)
    {:ok, state}
  end

  def handle_info(:off, _state) do
    Logger.info("In handle_call off: Disabling LED")
    led_off()
    new_state = :on
    Process.send_after(self(), new_state, 2_000)
    {:noreply, new_state}
  end

  def handle_info(:on, _state) do
    Logger.info("In handle_call on: Enabling LED")
    led_on()
    new_state = :off
    Process.send_after(self(), new_state, 2_000)
    {:noreply, new_state}
  end

  defp led_on do
    Logger.info("Enabling LED")
    Leds.set(green: true)
  end

  defp led_off do
    Logger.info("Disabling LED")
    Leds.set(green: false)
  end
end
