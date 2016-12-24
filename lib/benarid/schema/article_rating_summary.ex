defmodule BenarID.Schema.ArticleRatingSummary do
  @moduledoc false

  use Ecto.Schema

  schema "article_rating_summary" do
    field :count, :integer
    field :sum, :integer

    belongs_to :article, BenarID.Schema.Article
    belongs_to :rating, BenarID.Schema.Rating

    timestamps()
  end

end
