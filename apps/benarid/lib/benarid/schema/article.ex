defmodule BenarID.Schema.Article do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  schema "articles" do
    field :url, :string

    belongs_to :portal, BenarID.Schema.Portal

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:url, :portal_id])
    |> validate_required([:url, :portal_id])
    |> unique_constraint(:url)
  end
end
