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

  @impl true
  def handle_cast({:subscribe_blocks, pid}, subscriptions) do
    %Subscriptions{blocks: block_subscriptions} = subscriptions

    block_subscriptions = [pid | block_subscriptions]

    subscriptions = %{subscriptions | blocks: block_subscriptions}

    {:noreply, subscriptions}
  end
end
