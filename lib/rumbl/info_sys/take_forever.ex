defmodule Rumbl.InfoSys.TakeForever do
  def start_link(_query, _query_ref, _owner, _limit) do
    Task.start_link(fn -> Process.sleep(:infinity) end)
  end
end
