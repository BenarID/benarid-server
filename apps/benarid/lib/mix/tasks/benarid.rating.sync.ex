defmodule Mix.Tasks.Benarid.Rating.Sync do
  use Mix.Task

  @shortdoc "Syncs ratings definition to DB"

  @moduledoc """
  Syncs ratings definition to DB.

      mix benarid.rating.sync
  """

  alias BenarID.Rating

  def run(args) do
    {:ok, _} = Application.ensure_all_started(:benarid)
    Logger.configure level: :warn

    file = if Mix.Project.umbrella? do
      "apps/benarid/priv/ratings.yml"
    else
      "priv/ratings.yml"
    end

    case OptionParser.parse(args) do
      {[], [], _} ->
        data = parse_file file
        Rating.sync(data)
        Mix.shell.info "Successfully synced ratings."
      _ ->
        Mix.raise "expected benarid.rating.sync to not receive any arguments."
    end
  end

  defp parse_file(file) do
    case File.read file do
      {:error, _} ->
        Mix.raise "error reading file #{file}: please ensure the file exists"
      {:ok, content} ->
        YamlElixir.read_from_string content
    end
  end

end
