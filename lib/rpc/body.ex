defmodule BitcoinCoreClient.Rpc.Body do
  def create(method, params) do
    %{
      jsonrpc: "1.0",
      id: "curltest",
      method: method,
      params: params
    }
    |> Jason.encode!()
  end
end
