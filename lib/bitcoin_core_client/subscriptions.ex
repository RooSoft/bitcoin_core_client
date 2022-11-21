defmodule BitcoinCoreClient.Subscriptions do
  @moduledoc """
  Keeps track of blocks and transactions ZMQ subscriptions
  """

  defstruct blocks: []

  alias BitcoinCoreClient.Subscriptions

  @server Subscriptions.Server

  @doc """
  Starts the subscriptions server
  """
  @spec start_link() :: {:ok, pid()} | :ignore | {:error, {:already_started, pid()} | term()}
  def start_link() do
    start_link(nil)
  end

  @doc """
  Starts the subscriptions server
  """
  @spec start_link(any()) :: {:ok, pid()} | :ignore | {:error, {:already_started, pid()} | term()}
  def start_link(_) do
    GenServer.start_link(@server, %Subscriptions{}, name: @server)
  end

  @doc """
  Returns a list of pids that subscribed to new bitcoin block messages
  """
  @spec get_blocks_subscriptions() :: list()
  def get_blocks_subscriptions() do
    GenServer.call(@server, {:get_block_subscriptions})
  end

  @doc """
  Subscribes the current process to receive bitcoin block messages
  """
  @spec subscribe_blocks() :: :ok
  def subscribe_blocks() do
    GenServer.cast(@server, {:subscribe_blocks, self()})
  end

  @doc """
  Unsubscribes the current process to receive bitcoin block messages
  """
  @spec unsubscribe_blocks() :: :ok
  def unsubscribe_blocks() do
    GenServer.cast(@server, {:unsubscribe_blocks, self()})
  end
end
