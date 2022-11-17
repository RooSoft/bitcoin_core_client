defmodule BitcoinCoreClient.Rpc do
  @moduledoc """
  Wraps Bitcon Core RPC functions calls in easy to use functions abstracting
  the HTTP communication details
  """

  alias BitcoinCoreClient.Http.Settings

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
    HTTPoison.post!(url(settings), post_body(method, parameters), [])
    |> Map.get(:body)
    |> Jason.decode!()
    |> Map.get("result")
  end

  defp url(settings) do
    "http://#{settings.username}:#{settings.password}@#{settings.ip}:#{settings.port}"
  end

  defp post_body(method, params) do
    %{
      jsonrpc: "1.0",
      id: "curltest",
      method: method,
      params: params
    }
    |> Jason.encode!()
  end
end
