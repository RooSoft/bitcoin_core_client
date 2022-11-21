defmodule BitcoinCoreClient.Zmq.BlockListener do
  @moduledoc """
  Establish a connection to the Bitcoin Core server and send messages when the node
  gets new blocks
  """

  alias BitcoinCoreClient.Zmq

  @server Zmq.BlockListener.Server

  def start_link(%Zmq.Settings{} = settings) do
    GenServer.start_link(@server, settings, name: @server)
  end
end
