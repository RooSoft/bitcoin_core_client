defmodule BitcoinCoreClient.Http do
  def get(settings, method, parameters) do
    url = get_url(settings)
    body = body_for(method, parameters)

    HTTPoison.post!(url, body, [])
    |> Map.get(:body)
    |> Jason.decode!()
    |> Map.get("result")
  end

  defp get_url(settings) do
    "http://#{settings.username}:#{settings.password}@#{settings.ip}:#{settings.port}"
  end

  defp body_for(method, params) do
    %{
      jsonrpc: "1.0",
      id: "curltest",
      method: method,
      params: params
    }
    |> Jason.encode!()
  end
end
