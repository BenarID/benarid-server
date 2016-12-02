defmodule BenarID.Schema.Portal do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  schema "portals" do
    field :slug, :string
    field :name, :string
    field :site_url, :string

    has_many :hosts, BenarID.Schema.PortalHost

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:slug, :name, :site_url])
    |> validate_required([:slug, :name, :site_url])
  end
end
