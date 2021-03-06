defmodule RedixPoolboy.Supervisor do
  require Logger

  @moduledoc """
  Redis connection pool supervisor to handle connections via pool and
  reduce the number of opened connections via GenServer.
  """
  use Supervisor

  def start_link do
    :supervisor.start_link(__MODULE__, [])
  end

  # TODO: add it as config options instead of compiled variables
  @pool_name :redis_pool

  alias RedixPoolboy.Config

  def init([]) do
    # Here are my pool options
    pool_options = [
      name: {:local, @pool_name},
      worker_module: RedixPoolboy.Worker,
      size: Config.get(:pool_size, 10),
      max_overflow: Config.get(:pool_max_overflow, 1)
    ]

    children = [
      :poolboy.child_spec(@pool_name, pool_options, [])
    ]

    supervise(children, strategy: :one_for_one)
  end

  @doc """
  Making query via connection pool using `%{command: command, params: params}` pattern.
  """
  def command(args) do
    :poolboy.transaction(
      @pool_name,
      fn (worker) -> GenServer.call(worker, %{command: :query, params: args}) end,
      Config.get(:timeout, 5000)
    )
  end

  def pipeline(args) do
    :poolboy.transaction(
      @pool_name,
      fn (worker) -> GenServer.call(worker, %{command: :query_pipe, params: args}) end,
      Config.get(:timeout, 5000)
    )
  end
end
