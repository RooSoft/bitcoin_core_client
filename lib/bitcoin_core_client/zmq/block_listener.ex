defmodule BitcoinCoreClient.Zmq.BlockListener do
  @moduledoc """
  Establish a connection to the Bitcoin Core server and send messages when the node
  gets new blocks
  """

  use GenServer

  require Logger

  alias BitcoinCoreClient.Zmq

  def start_link(%Zmq.Settings{} = settings) do
    GenServer.start_link(__MODULE__, settings, name: __MODULE__)
  end

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
    Logger.info("RECV started...")

    {:ok, block} = :chumak.recv(socket)

    Logger.info("received a block")
    IO.inspect(block)

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
end
