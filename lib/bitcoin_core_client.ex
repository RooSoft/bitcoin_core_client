defmodule BitcoinCoreClient do
  @moduledoc """
  Documentation for `BitcoinCoreClient`.
  """

  @callback get_block_hash(integer()) :: binary()
  @server BitcoinCoreClient.Server

  alias BitcoinCoreClient.Rpc

  def start_link(%Rpc.Settings{} = settings) do
    GenServer.start_link(@server, settings, name: @server)
  end

  def get_block_hash(height) do
    GenServer.call(@server, {:get_block_hash, height})
  end

  def get_block_by_hash(hash) do
    GenServer.call(@server, {:get_block_by_hash, hash})
  end

  def get_block_by_height(height) do
    GenServer.call(@server, {:get_block_by_height, height})
  end
end
