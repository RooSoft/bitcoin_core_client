defmodule BitcoinCoreClient.Subscriptions.Server do
  @moduledoc """
  Keeps track of blocks and transactions ZMQ subscriptions

  This is the server part of the BitcoinCoreClient.Subscriptions GenServer
  """

  use GenServer

  require Logger

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
    subscriptions =
      subscriptions
      |> add_block_subscription(pid)

    monitor(pid)

    {:noreply, subscriptions}
  end

  @impl true
  def handle_info({:DOWN, _reference, :process, pid, :normal}, subscriptions) do
    subscriptions =
      subscriptions
      |> remove_block_subscription(pid)

    {:noreply, subscriptions}
  end

  defp add_block_subscription(subscriptions, pid) do
    %Subscriptions{blocks: block_subscriptions} = subscriptions

    block_subscriptions = [pid | block_subscriptions]

    %{subscriptions | blocks: block_subscriptions}
  end

  defp remove_block_subscription(subscriptions, pid) do
    %Subscriptions{blocks: block_subscriptions} = subscriptions

    block_subscriptions = Enum.reject(block_subscriptions, &(&1 == pid))

    %{subscriptions | blocks: block_subscriptions}
  end

  defp monitor(pid) do
    Process.monitor(pid)
  end
end
