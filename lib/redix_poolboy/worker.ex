defmodule RedixPoolboy.Worker do
  @moduledoc """
  Worker for getting connction to Redis and run queries via `Redix`
  """
  require Logger

  import Redix

  use GenServer

  @doc"""
  State is storing %{conn: conn} for reusing it because of wrapping it by redis pool

  `state` - default state is `%{conn: nil}`
  """
  def start_link(_state) do
    :gen_server.start_link(__MODULE__, %{conn: nil}, [])
  end

  def init(state) do
    {:ok, state}
  end

  defmodule Connector do
    require Redix
    require Logger

    alias RedixPoolboy.Config

    @doc """
    Using config `redix_poolboy` to connect to redis server via `Redix`
    """
    def connect() do
      connection_string = Config.get(:connection_string)
      client = if connection_string do
        {:ok, client} = Redix.start_link(connection_string)

        client
      else
        host = Config.get(:host, "127.0.0.1")
        port = Config.get(:port, 6379)
        password = Config.get(:password, nil)
        database = Config.get(:db, 0)
        reconnect = Config.get(:reconnect, :no_reconnect)
        {:ok, client} = Redix.start_link(host: host, port: port, password: password, database: database)

        client
      end

      Logger.debug "[Connector] connecting to redis server..."

      client
    end

    @doc """
    Checking process alive or not in case if we don't have connection we should
    connect to redis server.
    """
    def ensure_connection(conn) do
      if Process.alive?(conn) do
        conn
      else
        Logger.debug "[Connector] redis connection is died, it will renew connection."
        connect()
      end
    end
  end

  @doc false
  def handle_call(%{command: command, params: params}, _from, %{conn: nil}) do
    conn = Connector.connect
    case command do
      :query -> {:reply, q(conn, params), %{conn: conn}}
      :query_pipe -> {:reply, p(conn, params), %{conn: conn}}
    end
  end

  @doc false
  def handle_call(%{command: command, params: params}, _from, %{conn: conn}) do
    conn = Connector.ensure_connection(conn)
    case command do
      :query -> {:reply, q(conn, params), %{conn: conn}}
      :query_pipe -> {:reply, p(conn, params), %{conn: conn}}
    end
  end

  @doc false
  def q(conn, params) do
    command(conn, params)
  end

  @doc false
  def p(conn, params) do
    pipeline(conn, params)
  end
end
