defmodule BenarID.Schema.Rating do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  schema "ratings" do
    field :slug, :string
    field :label, :string
    field :question, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:slug, :label, :question])
    |> validate_required([:slug, :label, :question])
    |> unique_constraint(:slug)
  end
end
