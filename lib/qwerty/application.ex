defmodule Qwerty.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      QwertyWeb.Telemetry,
      Qwerty.Repo,
      {DNSCluster, query: Application.get_env(:qwerty, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Qwerty.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Qwerty.Finch},
      # Start a worker by calling: Qwerty.Worker.start_link(arg)
      # {Qwerty.Worker, arg},
      # Start to serve requests, typically the last entry
      QwertyWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Qwerty.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    QwertyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
