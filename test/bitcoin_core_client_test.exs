defmodule BitcoinCoreClientTest do
  use ExUnit.Case
  doctest BitcoinCoreClient

  test "greets the world" do
    assert BitcoinCoreClient.hello() == :world
  end
end
