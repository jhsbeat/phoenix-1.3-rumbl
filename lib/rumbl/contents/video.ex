defmodule Rumbl.Contents.Video do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rumbl.Contents.Video


  schema "videos" do
    field :description, :string
    field :title, :string
    field :url, :string
    belongs_to :user, Rumbl.Accounts.User
    belongs_to :category, Rumbl.Contents.Category

    timestamps()
  end

  @required [:user_id, :url, :title, :description]
  @optional [:category_id]

  @doc false
  def changeset(%Video{} = video, attrs) do
    video
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
  end
end
