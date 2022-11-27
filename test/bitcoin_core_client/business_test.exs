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

  test "get transaction by id", %{settings: settings, url: url} do
    id = "50cfd3361f7162b3c0c00dacd3d0e4ddf61e8ec0c51bfa54c4ca0e61876810a9"

    expect_get_transaction(url, id)

    transaction = Business.get_transaction(id, settings)

    assert transaction == some_transaction() |> Binary.from_hex()
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

  defp expect_get_transaction(
         url,
         "50cfd3361f7162b3c0c00dacd3d0e4ddf61e8ec0c51bfa54c4ca0e61876810a9" = id
       ) do
    body = Rpc.Body.create("getrawtransaction", [id])

    expect(HttpMock, :post!, fn ^url, ^body, [] -> some_transaction() end)
  end

  defp encoded_genesis_block() do
    "0100000000000000000000000000000000000000000000000000000000000000000000003ba3edfd7a7b12b27ac72c3e67768f617fc81bc3888a51323a9fb8aa4b1e5e4a29ab5f49ffff001d1dac2b7c0101000000010000000000000000000000000000000000000000000000000000000000000000ffffffff4d04ffff001d0104455468652054696d65732030332f4a616e2f32303039204368616e63656c6c6f72206f6e206272696e6b206f66207365636f6e64206261696c6f757420666f722062616e6b73ffffffff0100f2052a01000000434104678afdb0fe5548271967f1a67130b7105cd6a828e03909a67962e0ea1f61deb649f6bc3f4cef38c4f35504e51ec112de5c384df7ba0b8d578a4c702b6bf11d5fac00000000"
  end

  defp some_transaction() do
    "01000000010000000000000000000000000000000000000000000000000000000000000000ffffffff41fc70035c7a81bc6f4876c6036e4bc4080eaf81377bc9672828061491e79df5d4ddf1d65b058ccb30563f1f1c14f658607bd2c7138e87e480bcec3f5b91d041d041ffffffff1173f6e61100000000434104fbcaecde4b9ef952cdedc4d8de13a57c1571c546f281d66a2888cfcae49e7d7bdf9d53856b523e18604daf99f20d421810b1be2a13e5e0dc66c04d9e65a65dadac48787d0100000000434104ffd03de44a6e11b9917f3a29f9443283d9871c9d743ef30d5eddcd37094b64d1b3d8090496b53256786bf5c82932ec23c3b74d9f05a6f95a8b5529352656664bac578c29c6000000001976a91438a81ace130f1899a9f782eb7e4773214f2a200d88ac226e9105000000001976a91452c5ea82a56a1b0ea3c728f8b1b1c9b7858e455688ac471a0d00000000001976a91454a70c3cf312ab8e2f9793448b920e41c03c95b788acd76b3800000000001976a9145a1a43e18bb3e624b0cb72ef773616850b5c646088aca2f20a00000000001976a9147ef2ef14e787c2145d6e631137980343ffc7538188ace6b50700000000001976a91483ef9395c4b6829e0609e7dfd5c5eb2c6fd6e4fc88acaf22bb08000000001976a9148d96361ba71598a993b909c5e0e80d752a5d565e88acf49e3b11000000001976a91494605280450f39bfb12be48d3b331490ff83b0e488ac8bd00a00000000001976a914951600543556f89a34f79de0ea75e447c585c08e88ac72630700000000001976a914ae449cb6b7ee14c2d60d2b4d09fe88db054bc85088ac83ea9102000000001976a914b1ba6f1e44d17006549c754ab61bc0d1fa65bfbe88ac95745f00000000001976a914dc94bc48a2fba690948713add3132dafad4d097b88ac2f418613000000001976a914e6cb8e55b58a274637581be44746059494b253ec88acbb997802000000001976a914f14ec835492ccccdf719092bef9153a77d843e8d88ac842a9517000000001976a9144c974fa629466c2a01b75c82e69968e1625521d988ac00000000"
  end
end
