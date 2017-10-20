defmodule Rumbl.Contents.Annotation do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rumbl.Contents.Annotation


  schema "annotations" do
    field :at, :integer
    field :body, :string
    belongs_to :user, Rumbl.Accounts.User
    belongs_to :video, Rumbl.Contents.Video

    timestamps()
  end

  @doc false
  def changeset(%Annotation{} = annotation, attrs) do
    annotation
    |> cast(attrs, [:body, :at])
    |> validate_required([:body, :at])
  end
end
