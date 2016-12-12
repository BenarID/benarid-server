defmodule BenarID.Article do

  import Ecto.Query

  alias BenarID.Schema.Article
  alias BenarID.{
    Portal,
    URL,
    Repo,
  }

  def process(url) do
    parsed_url = URI.parse url
    case Portal.find_by_host(parsed_url.host) do
      :not_found ->
        {:error, :not_found}
      {:found, portal} ->
        {_host, article_url} = URL.normalize_url(parsed_url.host, parsed_url.path)
        {:ok, article} = create_article_if_not_exist(article_url, portal.id)
        {:ok, article.id}
    end
  end

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

end
