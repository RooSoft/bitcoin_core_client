defmodule BitcoinCoreClient.Rpc.Http do
  @moduledoc """
  Wrapper around HTTPoison to allow testable RPC calls over HTTP
  """

  @callback start() :: any()
  @callback post!(binary(), binary(), list()) :: any()

  @doc """
  Starts the HTTP client
  """
  @spec start() :: :ok
  def start() do
    HTTPoison.start()
  end

  @doc """
  Sends a POST request over HTTP and returns the parsed result
  """
  @spec post!(binary(), binary(), list()) :: any()
  def post!(url, post_body, headers) do
    HTTPoison.post!(url, post_body, headers)
    |> Map.get(:body)
    |> Jason.decode!()
    |> Map.get("result")
  end
end
