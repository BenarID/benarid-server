defmodule BenarID.URL do
  @moduledoc """
  Module for parsing URL logic.
  """

  def normalize_url("m.detik.com", path) do
    splitted_path = path |> String.split("/")
    category = Enum.at splitted_path, 1
    new_host = "#{category}.detik.com"
    new_path = splitted_path |> Enum.drop(2) |> Enum.join("/")
    {new_host, "#{new_host}/#{new_path}"}
  end
  def normalize_url(host, path), do: {host, "#{host}#{path}"}

end
