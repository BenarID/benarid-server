defmodule BenarID.Schema.TokenBlacklist do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false
  schema "token_blacklist" do
    field :token, :string, primary_key: true
    field :expire_at, :integer
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:token, :expire_at])
    |> validate_required([:token, :expire_at])
    |> unique_constraint(:token)
  end
end
