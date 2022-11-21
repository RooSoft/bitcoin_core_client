defmodule BitcoinCoreClient.Zmq.Settings do
  @moduledoc """
  A simple struct containing ip, port, credentials and a reference to the module
  to use for HTTP calls
  """

  defstruct [:ip, :port]
end
