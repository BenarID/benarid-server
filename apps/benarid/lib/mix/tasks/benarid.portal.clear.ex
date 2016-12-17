defmodule Mix.Tasks.Benarid.Portal.Clear do
  use Mix.Task

  @shortdoc "Clears portals from DB"

  @moduledoc """
  Clears portal from DB.

      mix benarid.portal.clear
  """

  alias BenarID.Portal

  def run(args) do
    if Mix.env == :prod do
      Mix.raise "cannot run benarid.portal.clear in :prod environments."
    end
    
    {:ok, _} = Application.ensure_all_started(:benarid)
    Logger.configure level: :warn

    case OptionParser.parse(args) do
      {[], [], _} ->
        {delete_count, _} = Portal.clear()
        Mix.shell.info "Successfully cleared #{delete_count} portals."
      _ ->
        Mix.raise "expected benarid.portal.clear to not receive any arguments."
    end
  end

end
