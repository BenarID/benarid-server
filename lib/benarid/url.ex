defmodule BenarID.URL do
  @moduledoc false

  def normalize_url("m.detik.com", path) do
    splitted_path = path |> String.split("/")
    category = Enum.at splitted_path, 1
    new_host = "#{category}.detik.com"
    new_path = splitted_path |> Enum.drop(2) |> Enum.join("/")
    {new_host, "#{new_host}/#{new_path}"}
  end
  def normalize_url(host, path), do: {host, "#{host}#{path}"}

  def valid_article_url?([_sub, "detik", "com"], url) do
    # Articles in detik always have an integer identifier,
    # sometimes prepended by "d-".
    url |> String.match?(~r/\/(d-)?\d{6,12}+\//)
  end

  def valid_article_url?([_sub, "kompas", "com"], url) do
    # Articles in kompas always have an integer identifier.
    url |> String.match?(~r/\/\d{6,12}+\//)
  end

end
