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
      {:error, _id, %Ecto.Changeset{errors: [article_id: _]}, _} ->
        {:error, :not_found}
      {:error, _id, %Ecto.Changeset{errors: [member_id: _]}, _} ->
        {:error, :has_rated}
      {:error, _id, %Ecto.Changeset{errors: [value: _]}, _} ->
        {:error, :invalid_value}
      {:error, _id, %Ecto.Changeset{errors: [rating_id: _]}, _} ->
        {:error, :invalid_value}
    end
  end

  def sync(data) do
    multi =
      data
      |> Enum.map(fn rating -> Rating.changeset(%Rating{}, rating) end)
      |> Enum.reduce(Multi.new, fn changeset, multi ->
        Multi.insert multi, Ecto.UUID.generate(), changeset,
          on_conflict: [set: [label: changeset.changes.label]],
          conflict_target: :slug
      end)

    case Repo.transaction(multi) do
      {:ok, _} ->
        :ok
      error ->
        error
    end
  end

end
