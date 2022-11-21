defmodule BitcoinCoreClient.Subscriptions do
  @moduledoc """
  Keeps track of blocks and transactions ZMQ subscriptions
  """

  defstruct blocks: []

  alias BitcoinCoreClient.Subscriptions

  @server Subscriptions.Server

  def start_link() do
    start_link(nil)
  end

  def start_link(_) do
    GenServer.start_link(@server, %Subscriptions{}, name: @server)
  end

  def get_blocks_subscriptions() do
    GenServer.call(@server, {:get_block_subscriptions})
  end

  def subscribe_blocks() do
    GenServer.cast(@server, {:subscribe_blocks, self()})
  end
end