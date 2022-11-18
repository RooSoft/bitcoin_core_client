defmodule BitcoinCoreClient.Rpc.Settings do
  @moduledoc """
  A simple struct containing ip, port, credentials and a reference to the module
  to use for HTTP calls
  """

  defstruct [:ip, :port, :username, :password, http_module: BitcoinCoreClient.Rpc.Http]

  alias BitcoinCoreClient.Rpc.Settings

  @doc """
  Converts the struct into an URL that can be used to get information over a Bitcoin
  Core RPC endpoint

  ## Examples
      iex> %BitcoinCoreClient.Rpc.Settings{ip: "192.168.1.1", port: 8332, username: "me", password: "pwd"}
      ...> |> BitcoinCoreClient.Rpc.Settings.to_url()
      "http://me:pwd@192.168.1.1:8332"
  """
  @spec to_url(%Settings{}) :: binary()
  def to_url(%Settings{} = settings) do
    "http://#{settings.username}:#{settings.password}@#{settings.ip}:#{settings.port}"
  end
end
