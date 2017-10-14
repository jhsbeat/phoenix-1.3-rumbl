defmodule Rumbl.Repo do
  # use Ecto.Repo, otp_app: :rumbl

  # @doc """
  # Dynamically loads the repository url from the
  # DATABASE_URL environment variable.
  # """
  # def init(_, opts) do
  #   {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  # end

  alias Rumbl.Accounts.User

  def all(User) do
    [%User{id: "1", name: "jose", username: "josevalim", password: "elixir"},
     %User{id: "2", name: "Bruce", username: "redrapids", password: "7langs"},
     %User{id: "3", name: "Chris", username: "chrismccord", password: "phx"},
    ]
  end
  def all(_module) do
    []
  end

  def get(module, id) do
    all(module) |> Enum.find(&(&1.id == id))
  end

  def get_by(module, params) do
    all(module) |> Enum.find(fn map ->
      params |> Enum.all?(fn {key, val} -> Map.get(map, key) == val end)
    end)
  end
end
