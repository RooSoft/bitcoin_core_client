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
end
