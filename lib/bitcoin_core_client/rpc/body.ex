defmodule BitcoinCoreClient.Rpc.Body do
  @moduledoc """
  HTTP Helper, converting RPC commands into json that has to be sent over HTTP
  """

  @doc """
  Converts RPC commands into HTTP POST bodies

  ## Examples
      iex> BitcoinCoreClient.Rpc.Body.create("getblockhash", [0])
      ~S({"id":"curltest","jsonrpc":"1.0","method":"getblockhash","params":[0]})
  """
  @spec create(binary(), list()) :: binary()
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
