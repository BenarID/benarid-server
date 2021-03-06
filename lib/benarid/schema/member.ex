defmodule BenarID.Schema.Member do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  schema "members" do
    field :name, :string
    field :email, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :email])
    |> validate_required([:name, :email])
    |> unique_constraint(:email)
  end
end
