defmodule Chucky do
  use Application
  require Logger

  # Instead of creating an explicit supervisor, we import Supervisor.Spec and
  # use the Supervisor.start_link function directly from the start function.
  def start(type, _args) do
    import Supervisor.Spec

    children = [
      worker(Chucky.Server, [])
    ]

    case type do
      :normal ->
        Logger.info("Application is started on #{node}")

      {:takeover, old_node} ->
        Logger.info("#{node} is taking over #{old_node}")

      {:failover, old_node} ->
        Logger.info("#{old_node} is failing over to #{node}")
    end

    opts = [strategy: :one_for_one, name: {:global, Chucky.Supervisor}]
    Supervisor.start_link(children, opts)
  end

  def fact do
    Chucky.Server.fact
  end
end
