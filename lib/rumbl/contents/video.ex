defmodule Rumbl.Contents.Video do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rumbl.Contents.Video


  schema "videos" do
    field :description, :string
    field :title, :string
    field :url, :string
    belongs_to :user, Rumbl.Accounts.User

    timestamps()
  end

  @required [:url, :title, :description]
  @optional []

  @doc false
  def changeset(%Video{} = video, attrs) do
    video
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
  end
end
