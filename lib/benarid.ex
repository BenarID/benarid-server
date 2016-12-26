defmodule BenarID do
  @moduledoc """
  Main application of BenarID.

  This module also contains the public API for dealing with our data.
  """

  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(BenarID.Repo, []),
      # Start the endpoint when the application starts
      supervisor(BenarID.Endpoint, []),
      # Start your own worker by calling: BenarID.Worker.start_link(arg1, arg2, arg3)
      # worker(BenarID.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BenarID.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BenarID.Endpoint.config_change(changed, removed)
    :ok
  end

  ################
  ## Public API ##
  ################

  alias BenarID.{
    Article,
    Member,
    Rating,
  }

  def find_member_by_id(member_id) do
    Member.find_by_id(member_id)
  end

  def process_url(url, member_id) do
    Article.process_url(url, member_id)
  end

  def rate_article(ratings, member_id, article_id) do
    Rating.rate_article(ratings, member_id, article_id)
  end

end
