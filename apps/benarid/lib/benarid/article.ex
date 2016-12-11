defmodule BenarID.Article do

  alias BenarID.{
    Portal,
    URL,
  }

  def process(url) do
    parsed_url = URI.parse url
    case Portal.find_by_host(parsed_url.host) do
      :not_found ->
        {:error, :not_found}
      {:found, _portal} ->
        {host, article_url} = URL.normalize_url(parsed_url.host, parsed_url.path)
        # TODO: check if article is already on database
        {:ok, article_url}
    end
  end

end
