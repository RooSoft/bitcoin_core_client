defmodule BitcoinCoreClient.SubscriptionsTest do
  use ExUnit.Case, async: true

  alias BitcoinCoreClient.Subscriptions

  setup do
    Subscriptions.start_link()

    :ok
  end

  test "add a subscription for new blocks" do
    Subscriptions.subscribe_blocks()
    self_pid = self()

    block_subscriptions = Subscriptions.get_blocks_subscriptions()

    assert [^self_pid] = block_subscriptions
  end

  test "remove when subscribed process exits" do
    parent = self()

    subscriber =
      spawn(fn ->
        Subscriptions.subscribe_blocks()
        send(parent, :subscribed)

        receive do
          :exit -> send(parent, :killed)
        end
      end)

    receive do
      :subscribed -> :ok
    end

    subscriptions = Subscriptions.get_blocks_subscriptions()

    assert [^subscriber] = subscriptions

    send(subscriber, :exit)

    receive do
      :killed -> :ok
    end

    :timer.sleep(10)

    subscriptions = Subscriptions.get_blocks_subscriptions()

    assert [] = subscriptions
  end
end
