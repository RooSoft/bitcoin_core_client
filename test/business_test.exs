defmodule BitcoinCoreClient.BusinessTest do
  use ExUnit.Case, async: true

  import Mox

  doctest BitcoinCoreClient.Business

  alias BitcoinCoreClient.Rpc
  alias BitcoinCoreClient.Business

  setup do
    defmock(HttpMock, for: BitcoinCoreClient.Rpc.Http)

    expect(HttpMock, :start, fn -> :ok end)

    settings = %Rpc.Settings{
      username: "my_user",
      password: "my_password",
      ip: "electrum",
      port: 8332,
      http_module: HttpMock
    }

    %{settings: settings}
  end

  test "use block height to get the block's hash", %{settings: settings} do
    url = Rpc.Settings.to_url(settings)
    body = Rpc.Body.create("getblockhash", [0])

    expect(HttpMock, :post!, fn ^url, ^body, [] ->
      "000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f"
    end)

    height = 0

    hash = Business.get_block_hash(height, settings)

    assert hash == "000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f"
  end
end
