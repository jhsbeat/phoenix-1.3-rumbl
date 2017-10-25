defmodule InfoSys.Crash do
  def start_link(_query, _query_ref, _owner, _limit) do
    Task.start_link(fn -> raise "crashed" end)
  end
end
