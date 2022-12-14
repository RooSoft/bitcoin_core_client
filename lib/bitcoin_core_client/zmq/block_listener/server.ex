defmodule BitcoinCoreClient.Zmq.BlockListener.Server do
  use GenServer

  require Logger

  alias BitcoinCoreClient.Zmq
  alias BitcoinCoreClient.Subscriptions

  @impl true
  def init(%Zmq.Settings{ip: ip, port: port} = state) do
    socket =
      case :chumak.socket(:sub) do
        {:ok, socket} -> socket
        {:error, {:already_started, socket}} -> socket
      end

    :chumak.subscribe(socket, "rawblock")
    :chumak.connect(socket, :tcp, to_charlist(ip), port)

    state =
      state
      |> Map.put(:socket, socket)

    {:ok, state, {:continue, :start}}
  end

  @impl true
  def handle_continue(:start, socket) do
    send(self(), {:start, socket})

    {:noreply, socket}
  end

  @impl true
  def handle_info({:start, %{socket: socket}}, state) do
    {:ok, block} = :chumak.recv(socket)

    send_block_to_subscribers(block)

    send(self(), {:start, state})

    {:noreply, state}
  end

  @impl true
  def handle_info(data, state) do
    Logger.info("Got handle_info")
    IO.puts("|#{inspect(data)}|")

    {:noreply, state}
  end

  @impl true
  def handle_cast(data, state) do
    Logger.info("got a handle_cast")
    IO.puts("|#{inspect(data)}|")

    {:noreply, state}
  end

  defp send_block_to_subscribers(block) do
    Subscriptions.get_blocks_subscriptions()
    |> Enum.each(&send(&1, block))
  end
end
