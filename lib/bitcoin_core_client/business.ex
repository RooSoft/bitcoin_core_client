defmodule BitcoinCoreClient.Business do
  @moduledoc """
  Makes the RPC calls and returns the results in bitstring format
  """

  alias BitcoinCoreClient.Rpc

  @doc """
  Converts a block height into a block hash

  ## Examples
      iex> BitcoinCoreClient.Business.get_block_hash(0, settings)
      ...> "000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f"
  """
  @spec get_block_hash(integer(), %Rpc.Settings{}) :: binary()
  def get_block_hash(height, settings) do
    Rpc.call(settings, "getblockhash", [height])
  end

  @doc """
  Returns the block corresponding to the hash sent as a parameter

  ## Examples
      iex> "000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f"
      ...> |> BitcoinCoreClient.Business.get_block_by_hash()
      %Block{...}
  """
  @spec get_block_by_hash(binary(), %Rpc.Settings{}) :: {:ok, bitstring()} | {:error, binary}
  def get_block_by_hash(block_hash, settings) do
    Rpc.call(settings, "getblock", [block_hash, 0])
    |> Binary.from_hex()
  end

  @doc """
  Returns the block corresponding to the block height sent as a parameter

  ## Examples
      iex> 0
      ...> |> BitcoinCoreClient.Business.get_block_by_height()
      %Block{...}
  """
  @spec get_block_by_height(integer(), %Rpc.Settings{}) :: {:ok, bitstring()} | {:error, binary}
  def get_block_by_height(height, settings) do
    height
    |> get_block_hash(settings)
    |> get_block_by_hash(settings)
  end
end
