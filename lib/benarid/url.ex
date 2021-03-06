defmodule BenarID.URL do
  @moduledoc """
  Module for URL computation, such as normalizing and checking if
  an article url is valid for a host.
  """

  @doc """
  Function to normalize (canonicalize) a url for an article.

  This is used for news portals that have different domains for
  its mobile and desktop sites, so that we can store the article
  canonically. In this case, we prefer the desktop version of
  the url.
  """
  def normalize_url(host, path)

  def normalize_url("m.detik.com", path) do
    splitted_path = path |> String.split("/")
    category = Enum.at splitted_path, 1
    new_host = "#{category}.detik.com"
    new_path = splitted_path |> Enum.drop(2) |> Enum.join("/")
    {new_host, "#{new_host}/#{new_path}"}
  end

  def normalize_url("m.liputan6.com", path) do
    splitted_path = path |> String.split("/")
    category = Enum.at splitted_path, 1
    new_host = "#{category}.liputan6.com"
    new_path = splitted_path |> Enum.drop(2) |> Enum.join("/")
    {new_host, "#{new_host}/#{new_path}"}
  end

  def normalize_url("m.bola.viva.co.id", path) do
    new_host = "www.viva.co.id"
    new_path = path |> String.replace("/news/", "/bola/")
    {new_host, "#{new_host}#{new_path}"}
  end

  def normalize_url(host, path) do
    new_host = normalize_host(String.split(host, "."))
    {new_host, "#{new_host}#{path}"}
  end

  defp normalize_host(["m", "cnnindonesia", "com"]),
    do: "www.cnnindonesia.com"
  defp normalize_host([_sub, "tempo", "co"]),
    do: "www.tempo.co"
  defp normalize_host([_sub, "republika", "co", "id"]),
    do: "www.republika.co.id"
  defp normalize_host(["republika", "co", "id"]),
    do: "www.republika.co.id"
  defp normalize_host(["m", "merdeka", "com"]),
    do: "www.merdeka.com"
  defp normalize_host(["sport", "viva", "co", "id"]),
    do: "news.viva.co.id"
  defp normalize_host([_sub, "news", "viva", "co", "id"]),
    do: "news.viva.co.id"
  defp normalize_host(["m", sub, "viva", "co", "id"]),
    do: "#{sub}.viva.co.id"
  defp normalize_host(host_segments),
    do: Enum.join(host_segments, ".")

  @doc """
  Function to validate if, given a `host_segments` and a `url`, it
  is a valid article url of the portal.

  This is so that we only process article pages, and not, for example,
  index pages, news listing, and so on.

  The `host_segments` is the host, splitted by "." for pattern matching.
  """
  def valid_article_url?(host_segments, url)

  def valid_article_url?([_sub, "detik", "com"], url) do
    # Articles in detik always have an integer identifier,
    # sometimes prepended by "d-".
    url |> String.match?(~r/\/(d-)?\d{6,12}\//)
  end

  def valid_article_url?([_sub, "kompas", "com"], url) do
    # Articles in kompas always have an integer identifier.
    url |> String.match?(~r/\/\d{6,12}\//)
  end

  def valid_article_url?([_sub, "cnnindonesia", "com"], url) do
    # Articles in cnnindonesia always have an integers separated by
    # two dashes as an identifier..
    url |> String.match?(~r/\/\d{13,16}-\d{2,5}-\d{5,8}\//)
  end

  def valid_article_url?([_sub, "bbc", "com"], url) do
    # Articles in bbc indonesia always starts with /indonesia, and
    # a segment containing category and integer identifier.
    url |> String.match?(~r/\/indonesia\/\w+-\d{7,10}$/)
  end

  def valid_article_url?([_sub, "tempo", "co"], url) do
    # Articles in tempo follows these validation rules.
    validations = [
      # Has date segments followed by an integer identifier
      url |> String.match?(~r/\/\d{4}\/\d{2}\/\d{2}\/\d+\//),
      # Unique for beritafoto, does not have date segments.
      url |> String.match?(~r/\/beritafoto\/\d+\//),
    ]
    # Check if any of the validations pass.
    Enum.any? validations, &(&1)
  end

  def valid_article_url?([_sub, "thejakartapost", "com"], url) do
    # Articles in the jakarta post has a date segment and always
    # ends with .html.
    url |> String.match?(~r/\/\d{4}\/\d{2}\/\d{2}\/.+\.html$/)
  end

  def valid_article_url?([_sub, "republika", "co", "id"], url) do
    # Articles in republika has date segments in the form of yy-mm-dd.
    url |> String.match?(~r/\/\d{2}\/\d{2}\/\d{2}\//)
  end

  def valid_article_url?([_sub, "merdeka", "com"], url) do
    # Articles in merdeka is always two segments by category and ends
    # with .html.
    url |> String.match?(~r/\/\w+\/.+\.html$/)
  end

  def valid_article_url?([_sub, "viva", "co", "id"], url) do
    # Articles in viva has integer identifier followed by slug as the
    # last segment, separated by a dash.
    url |> String.match?(~r/\/\d{5,8}-\w+/)
  end

  def valid_article_url?([_sub, "liputan6", "com"], url) do
    # Articles in kompas always have an integer identifier.
    url |> String.match?(~r/\/\d{6,12}\//)
  end

end
