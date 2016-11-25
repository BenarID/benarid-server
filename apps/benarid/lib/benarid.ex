defmodule BenarID do
  @moduledoc """
  Application for interfacing to BenarID database. Contains all the
  business logic for manipulating data.
  """

  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      worker(BenarID.Repo, []),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BenarID.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
