defmodule BenarIDWeb.TokenHelper do
  @moduledoc """
  Token related utilities.
  """

  def fetch_token_from_headers([]), do: nil
  def fetch_token_from_headers([token|_tail]) do
    token
    |> String.replace("Bearer ", "")
    |> String.trim
  end

end
