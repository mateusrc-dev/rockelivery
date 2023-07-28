defmodule Rockelivery.Orders.ReportRunner do
  use GenServer
  alias Rockelivery.Orders.Report

  require Logger

  # client
  def start_link(_initial_stack) do
    GenServer.start_link(__MODULE__, %{})
  end

  # server
  @impl true
  def init(state) do
    Logger.info("Report Runner Started...")
    schedule_report_generation()
    {:ok, state}
  end

  @impl true
  # receive anything of message
  def handle_info(:generate, state) do
    Logger.info("Generating report...")

    schedule_report_generation()
    Report.create()

    {:noreply, state}
  end

  def schedule_report_generation do
    Process.send_after(self(), :generate, 1000 * 10)
  end
end
