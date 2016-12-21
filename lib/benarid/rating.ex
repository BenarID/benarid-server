defmodule BenarID.Rating do
  @moduledoc """
  Interface for managing portals.
  """

  alias Ecto.Multi
  alias BenarID.Repo
  alias BenarID.Schema.Rating

  def sync(data) do
    multi =
      data
      |> Enum.map(fn rating -> Rating.changeset(%Rating{}, rating) end)
      |> Enum.reduce(Multi.new, fn changeset, multi ->
        Multi.insert(multi, Ecto.UUID.generate(), changeset)
      end)

    case Repo.transaction(multi) do
      {:ok, _} ->
        :ok
      error ->
        error
    end
  end

end
