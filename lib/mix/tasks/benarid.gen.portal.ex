defmodule Mix.Tasks.Benarid.Gen.Portal do
  use Mix.Task

  @shortdoc "Generates a Portal definition"

  @moduledoc """
  Generates a Portal definition.

      mix benarid.gen.portal <filename>

  The definition will be generated in "priv/portals/<filename>.yml".
  """

  import Mix.Generator
  import Mix.BenarID

  def run(args) do
    no_umbrella!("benarid.gen.portal")
    case OptionParser.parse(args) do
      {_, [], _} ->
        Mix.raise "expected benarid.gen.portal to receive the file name."
      {_, [name], _} ->
        path = Path.relative_to "priv/portals", Mix.Project.app_path()
        file = Path.join path, "#{name}.yml"
        create_directory path
        create_file file, portal_template([])

        Mix.shell.info """

        You're almost done!
        Please fill in the definition in #{inspect file}.
        Use the comments to help you fill in the details.
        When you're done, run it with:

            $ mix benarid.portal.sync #{name}
        """
    end
  end

  embed_template :portal, """
  # Display name for the portal. Example: Detik.com
  name:

  # Unique, lowercase, URL safe slug. Example: detikcom
  slug:

  # Main site of this portal. Example: http://www.detik.com
  site_url:

  # Hosts containing articles of this portal. May add more if necessary.
  # Leave out the protocol (http/https). Example valid host:
  #   news.detik.com, finance.detik.com, etc.
  hosts:
    -
    -
  """
end
