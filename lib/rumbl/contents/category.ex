defmodule Rumbl.Contents.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rumbl.Contents.Category


  schema "categories" do
    field :name, :string
    has_many :videos, Rumbl.Contents.Video

    timestamps()
  end

  @doc false
  def changeset(%Category{} = category, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  import Ecto.Query

  def alphabetical(query) do
    from c in query, order_by: c.name
  end

  def names_and_ids(query) do
    from c in query, select: {c.name, c.id}
  end
end
