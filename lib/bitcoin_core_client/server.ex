defmodule BitcoinCoreClient.Server do
  @moduledoc """
  Keeps track of blocks and transactions ZMQ subscriptions

  This is the server part of the GenServer
  """

  use GenServer

  alias BitcoinCoreClient.Business

  @impl true
  def init(settings) do
    settings.http_module.start()

    {:ok, settings}
  end

  @impl true
  def handle_call({:get_block_hash, height}, _from, settings) do
    block_hash = Business.get_block_hash(height, settings)

    {:reply, block_hash, settings}
  end

  @impl true
  def handle_call({:get_block_by_hash, hash}, _from, settings) do
    block = Business.get_block_by_hash(hash, settings)

    {:reply, block, settings}
  end

  @impl true
  def handle_call({:get_block_by_height, height}, _from, settings) do
    block = Business.get_block_by_height(height, settings)

    {:reply, block, settings}
  end
end
