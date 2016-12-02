defmodule BenarID.Schema.PortalHost do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  schema "portal_hosts" do
    field :hostname, :string

    belongs_to :portal, BenarID.Schema.Portal

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:hostname, :portal_id])
    |> validate_required([:hostname, :portal_id])
    |> assoc_constraint(:portal)
  end
end
