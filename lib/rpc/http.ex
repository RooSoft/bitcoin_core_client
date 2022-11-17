defmodule BitcoinCoreClient.Rpc.Http do
  @callback start() :: any()
  @callback post!(binary(), binary(), list()) :: any()

  def start() do
    HTTPoison.start()
  end

  def post!(url, post_body, headers) do
    HTTPoison.post!(url, post_body, headers)
    |> Map.get(:body)
    |> Jason.decode!()
    |> Map.get("result")
  end
end
