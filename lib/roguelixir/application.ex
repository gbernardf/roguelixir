defmodule Roguelixir.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      RoguelixirWeb.Telemetry,
      Roguelixir.Repo,
      {DNSCluster, query: Application.get_env(:roguelixir, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Roguelixir.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Roguelixir.Finch},
      # Start a worker by calling: Roguelixir.Worker.start_link(arg)
      # {Roguelixir.Worker, arg},
      # Start to serve requests, typically the last entry
      RoguelixirWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Roguelixir.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RoguelixirWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
