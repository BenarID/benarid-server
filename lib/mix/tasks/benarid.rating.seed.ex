defmodule Mix.Tasks.Benarid.Rating.Seed do
  use Mix.Task

  @shortdoc "Seeds ratings for an article"

  @moduledoc """
  Syncs ratings definition to DB.

      mix benarid.rating.seed <article url>

  ### Example

      mix benarid.rating.seed "http://news.detik.com/som/article/url"
  """

  import Ecto.Query

  alias BenarID.Repo
  alias BenarID.Schema.Member
  alias BenarID.Schema.Rating

  def run(args) do
    {:ok, _} = Application.ensure_all_started(:benarid)
    Logger.configure level: :warn

    case OptionParser.parse(args) do
      {[], [], _} ->
        Mix.raise "expected benarid.rating.seed to receive article url."
      {_, [url], _} ->
        {:ok, article_stats} = BenarID.Article.process_url(url, nil)
        members = Repo.all(from q in Member, where: like(q.email, "dummymember%"))
        ratings = Repo.all(Rating)
        for member <- members do
          random_rate(member, ratings, article_stats.id)
        end
        Mix.shell.info "Successfully seeded ratings for #{url}."
    end
  end

  defp random_rate(member, ratings, article_id) do
    seed_rating = Enum.map ratings, fn rating ->
      random_number = Enum.random(0..100)
      if random_number < 25 do
        {rating.id, 0}
      else
        {rating.id, 1}
      end
    end
    BenarID.Rating.rate_article(seed_rating, member.id, article_id)
  end

end
