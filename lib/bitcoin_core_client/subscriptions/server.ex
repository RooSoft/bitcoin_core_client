defmodule BitcoinCoreClient.Subscriptions.Server do
  use GenServer

  alias BitcoinCoreClient.Subscriptions

  @impl true
  def init(subscriptions) do
    {:ok, subscriptions}
  end

  @impl true
  def handle_call({:get_block_subscriptions}, _from, subscriptions) do
    %Subscriptions{blocks: blocks} = subscriptions

    {:reply, blocks, subscriptions}
  end
end
