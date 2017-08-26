defmodule BenarID.Schema.TokenBlacklist do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false
  schema "token_blacklist" do
    field :token, :string, primary_key: true
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:token])
    |> validate_required([:token])
    |> unique_constraint(:token)
  end
end
