defmodule BitcoinCoreClient do
  @moduledoc """
  Documentation for `BitcoinCoreClient`.
  """

  use GenServer

  alias BitcoinCoreClient.Http
  alias BitcoinCoreClient.Business

  def start_link(%Http.Settings{} = settings) do
    GenServer.start_link(__MODULE__, settings, name: __MODULE__)
  end

  @impl true
  def init(settings) do
    HTTPoison.start()

    {:ok, settings}
  end

  def get_block_hash(height) do
    GenServer.call(__MODULE__, {:get_block_hash, height})
  end

  def get_block_by_hash(hash) do
    GenServer.call(__MODULE__, {:get_block_by_hash, hash})
  end

  def get_block_by_height(height) do
    GenServer.call(__MODULE__, {:get_block_by_height, height})
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
