defmodule AocEx.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AocExWeb.Telemetry,
      AocEx.Repo,
      {DNSCluster, query: Application.get_env(:aoc_ex, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: AocEx.PubSub},
      # Start a worker by calling: AocEx.Worker.start_link(arg)
      # {AocEx.Worker, arg},
      # Start to serve requests, typically the last entry
      AocExWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AocEx.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AocExWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
