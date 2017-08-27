defmodule BenarID.BlacklistClearanceScheduler do
  @moduledoc """
  A GenServer that periodically does work to clear
  expired blacklisted tokens.

  Inspired by https://stackoverflow.com/a/32097971
  """

  require Logger

  alias BenarID.Auth

  @clearance_period Application.get_env(:benarid, :token_clearance_period)

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Logger.info("Initializing scheduler, running every hour.")
    schedule_clearance()
    {:ok, state}
  end

  def handle_info(:clear_expired_token, state) do
    Logger.info("Start clearing expired tokens from blacklist.")
    {:ok, count} = Auth.clear_expired_token_from_blacklist()
    Logger.info("Deleted #{count} expired tokens from blacklist.")
    schedule_clearance()
    {:noreply, state}
  end

  defp schedule_clearance do
    Process.send_after(self(), :clear_expired_token, @clearance_period)
  end
end
