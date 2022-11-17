defmodule BitcoinCoreClient.Business do
  alias BitcoinCoreClient.Rpc
  alias BitcoinLib.Block

  def get_block_hash(height, settings) do
    Rpc.call(settings, "getblockhash", [height])
  end

  def get_block_by_hash(block_hash, settings) do
    Rpc.call(settings, "getblock", [block_hash, 0])
    |> Binary.from_hex()
    |> Block.decode()
  end

  def get_block_by_height(height, settings) do
    height
    |> get_block_hash(settings)
    |> get_block_by_hash(settings)
  end
end
