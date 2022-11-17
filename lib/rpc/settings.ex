defmodule BitcoinCoreClient.Rpc.Settings do
  defstruct [:ip, :port, :username, :password, http_module: BitcoinCoreClient.Rpc.Http]

  alias BitcoinCoreClient.Rpc.Settings

  def to_url(%Settings{} = settings) do
    "http://#{settings.username}:#{settings.password}@#{settings.ip}:#{settings.port}"
  end
end
