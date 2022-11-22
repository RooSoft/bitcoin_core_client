defmodule BitcoinCoreClient.BusinessTest do
  use ExUnit.Case, async: true

  import Mox

  alias BitcoinCoreClient.Rpc
  alias BitcoinCoreClient.Business

  setup_all do
    defmock(HttpMock, for: BitcoinCoreClient.Rpc.Http)

    expect(HttpMock, :start, fn -> :ok end)

    settings = %Rpc.Settings{
      username: "my_user",
      password: "my_password",
      ip: "electrum",
      port: 8332,
      http_module: HttpMock
    }

    url = Rpc.Settings.to_url(settings)

    %{settings: settings, url: url}
  end

  test "use block height to get the block's hash", %{settings: settings, url: url} do
    height = 0

    expect_get_block_hash(url, height)

    hash = Business.get_block_hash(height, settings)

    assert hash == "000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f"
  end

  test "get block by hash", %{settings: settings, url: url} do
    block_hash = "000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f"

    expect_get_block(url, block_hash)

    block = Business.get_block_by_hash(block_hash, settings)

    assert block == encoded_genesis_block() |> Binary.from_hex()
  end

  test "get block by height", %{settings: settings, url: url} do
    height = 0
    block_hash = "000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f"

    expect_get_block_hash(url, height)
    expect_get_block(url, block_hash)

    block = Business.get_block_by_height(height, settings)

    assert block == encoded_genesis_block() |> Binary.from_hex()
  end

  defp expect_get_block_hash(url, 0 = height) do
    body = Rpc.Body.create("getblockhash", [height])

    expect(HttpMock, :post!, fn ^url, ^body, [] ->
      "000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f"
    end)
  end

  defp expect_get_block(
         url,
         "000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f" = block_hash
       ) do
    body = Rpc.Body.create("getblock", [block_hash, 0])

    expect(HttpMock, :post!, fn ^url, ^body, [] -> encoded_genesis_block() end)
  end

  defp encoded_genesis_block() do
    "0100000000000000000000000000000000000000000000000000000000000000000000003ba3edfd7a7b12b27ac72c3e67768f617fc81bc3888a51323a9fb8aa4b1e5e4a29ab5f49ffff001d1dac2b7c0101000000010000000000000000000000000000000000000000000000000000000000000000ffffffff4d04ffff001d0104455468652054696d65732030332f4a616e2f32303039204368616e63656c6c6f72206f6e206272696e6b206f66207365636f6e64206261696c6f757420666f722062616e6b73ffffffff0100f2052a01000000434104678afdb0fe5548271967f1a67130b7105cd6a828e03909a67962e0ea1f61deb649f6bc3f4cef38c4f35504e51ec112de5c384df7ba0b8d578a4c702b6bf11d5fac00000000"
  end
end
