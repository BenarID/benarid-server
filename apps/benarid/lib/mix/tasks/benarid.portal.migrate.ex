defmodule Mix.Tasks.Benarid.Portal.Migrate do
  use Mix.Task

  @shortdoc "Inserts portal definition(s) to DB"

  @moduledoc """
  Inserts a portal and its hosts from a definition.

      mix benarid.portal.create <filename>

  If you want to insert all portals, use the `--all` flag.

      mix benarid.portal.create --all
  """

  alias BenarID.Portal

  @switches [:all]

  def run(args) do
    {:ok, _} = Application.ensure_all_started(:benarid)
    Logger.configure level: :warn

    path = if Mix.Project.umbrella? do
      "apps/benarid/priv/portals"
    else
      "priv/portals"
    end
    
    case OptionParser.parse(args, switches: @switches) do
      {[], [], _} ->
        Mix.raise "expected benarid.portal.migrate to receive the file name or --all flag."
      {[all: true], _, _} ->
        {:ok, files} = File.ls path
        for name <- files do
          file = Path.join path, name
          run_single(file)
        end
      {_, [name], _} ->
        file = Path.join path, "#{name}.yml"
        run_single(file)
    end
  end

  defp run_single(file) do
    data = parse_file file
    portal_data = %{
      name: data["name"],
      slug: data["slug"],
      site_url: data["site_url"]
    }
    hosts = data["hosts"]
    {:ok, portal} = Portal.create_portal(portal_data)
    Portal.populate_hosts(portal, hosts)
    Mix.shell.info "Successfully migrated portal #{portal.name}."
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
