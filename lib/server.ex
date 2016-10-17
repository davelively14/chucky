defmodule Chucky.Server do
  use GenServer

  #######
  # API #
  #######

  # Uses :global to register the module name on the global_name_server.
  def start_link do
    GenServer.start_link(__MODULE__, [], [name: {:global, __MODULE__}])
  end

  # Because we registered the Server globally, all calls and casts must be
  # prefixed with the :global tag.
  def fact do
    GenServer.call({:global, __MODULE__}, :fact)
  end

  #############
  # Callbacks #
  #############

  # Reads a file called facts.txt, splits by line, and initializes the state to
  # a list of each split line.
  def init([]) do
    :random.seed(:os.timestamp)
    facts =
      "facts.txt"
      |> File.read!
      |> String.split("\n")
    {:ok, facts}
  end

  # Randomly returns a fact
  def handle_call(:fact, _from, facts) do
    random_fact =
      facts
      |> Enum.shuffle
      |> List.first

    {:reply, random_fact, facts}
  end
end
