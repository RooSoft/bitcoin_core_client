defmodule BitcoinCoreClient.Rpc do
  @moduledoc """
  Wraps Bitcon Core RPC functions calls in easy to use functions abstracting
  the HTTP communication details
  """

  alias BitcoinCoreClient.Rpc.{Body, Settings}

  @doc """
  Takes
  - connection settings
  - a function name
  - the function's arguments in a list format

  And makes a Bitcoin Core RPC call, returning the result

  API documentation: https://developer.bitcoin.org/reference/rpc/
  """
  @spec call(%Settings{}, binary(), list()) :: binary() | number()
  def call(settings, method, parameters) do
    url = Settings.to_url(settings)
    post_body = Body.create(method, parameters)

    settings.http_module.post!(url, post_body, [])
  end
end
