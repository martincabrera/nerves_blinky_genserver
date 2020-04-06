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

  def init(state) do
    led_light(:on)
    state = :off
    Process.send_after(self(), state, 1_000)
    {:ok, state}
  end

  def handle_info(_, state) do
    Logger.info("In handle_info: #{state}")
    new_state = transform_state(state)
    new_state |> led_light
    Process.send_after(self(), new_state, 1_000)
    {:noreply, new_state}
  end

  defp led_light(:on) do
    Logger.info("Enabling LED")
    Leds.set(green: true)
  end

  defp led_light(:off) do
    Logger.info("Disabling LED")
    Leds.set(green: false)
  end

  defp transform_state(state) do
    output = if (state == :off), do: :on, else: :off

    output
  end
end
