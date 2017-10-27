defmodule InfoSys.Crash do
  @behaviour InfoSys.Backend

  @impl true
  def start_link(_query, _query_ref, _owner, _limit) do
    Task.start_link(fn -> raise "crashed" end)
  end
end
