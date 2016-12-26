defmodule BenarID.Rating do
  @moduledoc false

  alias Ecto.Multi
  alias BenarID.Repo
  alias BenarID.Schema.Rating
  alias BenarID.Schema.ArticleRating

  def rate_article(ratings, member_id, article_id) do
    changesets = for {id, value} <- ratings do
      data = %{
        value: value,
        rating_id: id,
        member_id: member_id,
        article_id: article_id
      }
      ArticleRating.changeset(%ArticleRating{}, data)
    end

    multi =
      changesets
      |> Enum.reduce(Multi.new, fn changeset, multi ->
        Multi.insert(multi, Ecto.UUID.generate(), changeset)
      end)

    case Repo.transaction(multi) do
      {:ok, _} ->
        :ok
      {:error, _id, _changeset, _} ->
        :error
    end
  end

  def sync(data) do
    multi =
      data
      |> Enum.map(fn rating -> Rating.changeset(%Rating{}, rating) end)
      |> Enum.reduce(Multi.new, fn changeset, multi ->
        Multi.insert(multi, Ecto.UUID.generate(), changeset)
      end)

    case Repo.transaction(multi) do
      {:ok, _} ->
        :ok
      error ->
        error
    end
  end

end
