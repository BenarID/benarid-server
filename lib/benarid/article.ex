defmodule BenarID.Article do
  @moduledoc false

  import Ecto.Query

  alias BenarID.Schema.{
    Article,
    ArticleRating,
    ArticleRatingSummary,
    Rating,
  }
  alias BenarID.{
    Portal,
    Repo,
    URL,
  }

  def process_url(url, member_id) do
    parsed_url = URI.parse url
    case Portal.find_by_host(parsed_url.host) do
      :not_found ->
        {:error, :not_found}
      {:found, portal} ->
        {host, article_url} = URL.normalize_url(parsed_url.host, parsed_url.path)

        case URL.valid_article_url?(String.split(host, "."), article_url) do
          false ->
            {:error, :invalid_url}
          true ->
            {:ok, article} = create_article_if_not_exist(article_url, portal.id)
            stats(article.id, member_id)
        end
    end
  end

  # Private API

  defp create_article_if_not_exist(url, portal_id) do
    case find_by_url(url) do
      :not_found ->
        create_article(url, portal_id)
      {:found, article} ->
        {:ok, article}
    end
  end

  defp find_by_url(article_url) do
    query = from a in Article,
      where: a.url == ^article_url

    case Repo.one(query) do
      nil ->
        :not_found
      article ->
        {:found, article}
    end
  end

  defp create_article(url, portal_id) do
    changeset = Article.changeset(%Article{}, %{url: url, portal_id: portal_id})

    case Repo.insert(changeset) do
      {:ok, article} ->
        {:ok, article}
      {:error, _} ->
        {:error, changeset.errors}
    end
  end

  defp stats(article_id, nil), do: fetch_rating_summary(article_id)
  defp stats(article_id, member_id) do
    case fetch_rating_summary(article_id) do
      {:ok, article_stats} ->
        article_stats =
          article_stats
          |> Map.put(:id, article_id)
          |> Map.put(:rated, rated?(article_id, member_id))
        {:ok, article_stats}
      :error ->
        :error
    end
  end

  defp fetch_rating_summary(article_id) do
    query = from r in Rating,
      left_join: ar in ArticleRatingSummary,
        on: ar.article_id == ^article_id and ar.rating_id == r.id,
      select: %{
        id: r.id,
        slug: r.slug,
        label: r.label,
        value: fragment("COALESCE(1.0 * ? / ?, 0)", ar.sum, ar.count),
        count: fragment("COALESCE(?, 0)", ar.count),
      }

    case Repo.all(query) do
      nil ->
        :error
      rows ->
        {:ok, %{rating: rows}}
    end
  end

  defp rated?(article_id, member_id) do
    query = from ar in ArticleRating,
      where: ar.article_id == ^article_id,
      where: ar.member_id == ^member_id

    Repo.aggregate(query, :count, :id) > 0
  end

end
