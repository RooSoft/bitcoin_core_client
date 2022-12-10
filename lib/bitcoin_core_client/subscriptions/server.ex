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

    {:reply, get_pids(blocks), subscriptions}
  end

  @impl true
  def handle_cast({:subscribe_blocks, pid}, subscriptions) do
    ref = monitor(pid)

    subscriptions =
      subscriptions
      |> add_block_subscription(pid, ref)

    {:noreply, subscriptions}
  end

  @impl true
  def handle_cast({:unsubscribe_blocks, pid}, subscriptions) do
    %Subscriptions{blocks: block_subscriptions} = subscriptions
    ref = ref_from_pid(block_subscriptions, pid)
    demonitor(ref)

    subscriptions =
      subscriptions
      |> remove_block_subscription(pid)

    {:noreply, subscriptions}
  end

  @impl true
  def handle_info({:DOWN, _reference, :process, pid, _}, subscriptions) do
    subscriptions =
      subscriptions
      |> remove_block_subscription(pid)

    {:noreply, subscriptions}
  end

  defp add_block_subscription(subscriptions, pid, ref) do
    %Subscriptions{blocks: block_subscriptions} = subscriptions

    block_subscriptions =
      [{pid, ref} | block_subscriptions]
      |> Enum.uniq()

    %{subscriptions | blocks: block_subscriptions}
  end

  defp remove_block_subscription(subscriptions, pid) do
    %Subscriptions{blocks: block_subscriptions} = subscriptions

    block_subscriptions = Enum.reject(block_subscriptions, &is_pid(&1, pid))

    %{subscriptions | blocks: block_subscriptions}
  end

  defp monitor(pid) do
    Process.monitor(pid)
  end

  defp demonitor(ref) do
    Process.demonitor(ref)
  end

  defp ref_from_pid(subscriptions, pid) do
    subscriptions
    |> Enum.find(&is_pid(&1, pid))
    |> get_ref
  end

  defp get_pids(blocks) do
    blocks
    |> Enum.map(&get_pid(&1))
  end

  defp is_pid(tuple, pid) do
    elem(tuple, 0) == pid
  end

  defp get_pid(tuple) do
    elem(tuple, 0)
  end

  defp get_ref(tuple) do
    elem(tuple, 1)
  end
end
