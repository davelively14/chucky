# This is the Chucky application behavior that will serve as the entry point to
# the entire application. Chucky.fact will interact with the server api and
# return the fact about Chuck Norris.
defmodule Chucky do
  use Application
  require Logger

  # Instead of creating an explicit supervisor, we import Supervisor.Spec and
  # use the Supervisor.start_link function directly from the start function.
  # Notice that we're using type (which is a start_type data type from Erlang).
  # For non-distributed applications, this will usually be :normal, so we just
  # ignore it. In this case, we want to case off the type in order to account
  # for :takeover and :falover scenarios.
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
