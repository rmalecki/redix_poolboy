defmodule RedixPoolboy do
  @moduledoc ~S"""
  Application for running connection pool and redis connection inside.

  ## Example:

    ```elixir
    alias RedixPoolboy, as: Redis

    Redis.query(["SET", "key1", "value1"]) => "OK"
    Redis.query(["GET", "key1"]) => "value1"
    Redis.query(["GET", "key2"]) => nil

    Redis.command(["SET", "key1", "value1"]) => {:ok, "OK"}
    Redis.command(["GET", "key1"]) => {:ok, "value1"}
    Redis.command(["GET", "key2"]) => {:ok, nil}
    ```
  """

  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      %{id: RedixPoolboy.Supervisor, start: {RedixPoolboy, :start_link, []}, type: :supervisor}
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RedixPoolboy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc ~S"""
  `command` sends commands directly to Redis
  """
  def command(args) do
    RedixPoolboy.Supervisor.command(args)
  end
  def query(args) do
    {:ok, value} = command args
    value
  end

  @doc ~S"""
  `pipeline` sends multiple commands as batch directly to Redis.
  """
  def pipeline([]), do: {:ok, []}
  def pipeline(args) do
    RedixPoolboy.Supervisor.pipeline(args)
  end

  def query_pipe(args) do
    {:ok, value} = pipeline args
    value
  end
end
