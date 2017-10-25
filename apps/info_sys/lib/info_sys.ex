defmodule InfoSys do
  @backends [InfoSys.Wolfram, InfoSys.Crash]
  # @backends [InfoSys.Wolfram, InfoSys.Crash, InfoSys.TakeForever]
  # TakeForever 는 항상 timeout 까지 기다리게 만들기 때문에 개발에 불편함. Timeout 처리가 제대로 되는지 확인하고 싶을 때만 enable.

  defmodule Result do
    defstruct score: 0, text: nil, url: nil, backend: nil
  end

  def start_link(backend, query, query_ref, owner, limit) do
    backend.start_link(query, query_ref, owner, limit)
  end

  def compute(query, opts \\ []) do
    limit = opts[:limit] || 10
    backends = opts[:backends] || @backends

    before = Time.utc_now()
    result = backends
    |> Enum.map(&spawn_query(&1, query, limit))
    |> await_results(opts)
    |> Enum.sort(&(&1.score >= &2.score))
    |> Enum.take(limit)
    time = Time.diff(Time.utc_now(), before, :millisecond)
    IO.puts "Took #{time} milliseconds."
    result
  end

  defp spawn_query(backend, query, limit) do
    query_ref = make_ref()
    opts = [backend, query, query_ref, self(), limit]
    # Supervisor 밑에서 시작하기 때문에 crash 하더라도 현재 프로세스에 영향을 주지 않음.
    # restart: :temporary 기 때문에, die 하더라도 재시작하지 않음.
    {:ok, pid} = Supervisor.start_child(InfoSys.Supervisor, opts)
    monitor_ref = Process.monitor(pid)
    {pid, monitor_ref, query_ref}
  end

  defp await_results(children, opts) do
    timeout = opts[:timeout] || 10_000
    timer = Process.send_after(self(), :timedout, timeout)
    results = await_result(children, [], :infinity)
    cleanup(timer)
    results
  end

  defp await_result([head | tail], acc, timeout) do
    {pid, monitor_ref, query_ref} = head

    receive do
      {:results, ^query_ref, results} ->
        Process.demonitor(monitor_ref, [:flush])
        await_result(tail, results ++ acc, timeout)
      {:DOWN, ^monitor_ref, :process, ^pid, _reason} ->
        await_result(tail, acc, timeout)
      :timedout ->
        kill(pid, monitor_ref)
        await_result(tail, acc, 0)
    after timeout ->
        kill(pid, monitor_ref)
        await_result(tail, acc, 0)
    end
  end

  defp await_result([], acc, _), do: acc

  defp kill(pid, ref) do
    Process.demonitor(ref, [:flush])
    Process.exit(pid, :kill)
  end

  defp cleanup(timer) do
    :erlang.cancel_timer(timer)
    receive do
      :timedout ->
        :ok
    after 0 ->
        :ok
    end
  end
end
