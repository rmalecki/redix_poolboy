defmodule RedixPoolboy.Config do
  @doc """
  Return value by key from config.exs file.
  """
  def get(name, default \\ nil) do
    Application.get_env(:redix_poolboy, name, default)
  end
end
