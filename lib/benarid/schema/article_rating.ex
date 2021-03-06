defmodule BenarID.Schema.ArticleRating do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  schema "article_ratings" do
    field :value, :integer

    belongs_to :article, BenarID.Schema.Article
    belongs_to :rating, BenarID.Schema.Rating
    belongs_to :member, BenarID.Schema.Member

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:value, :article_id, :rating_id, :member_id])
    |> validate_required([:value, :article_id, :rating_id, :member_id])
    |> validate_inclusion(:value, 0..1)
    |> foreign_key_constraint(:article_id)
    |> foreign_key_constraint(:rating_id)
    |> unique_constraint(:member_id,
      name: :article_ratings_article_id_rating_id_member_id_index
    )
  end
end
