defmodule Contacts.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      ContactsWeb.Telemetry,
      Contacts.Repo,
      {DNSCluster, query: Application.get_env(:contacts, :dns_cluster_query) || :ignore},
      # Start the PubSub system
      {Phoenix.PubSub, name: Contacts.PubSub},
      # Starts a worker by calling: Contacts.Worker.start_link(arg)
      # {Contacts.Worker, arg},
      # Start to serve requests, typically the last entry
      ContactsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Contacts.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ContactsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
