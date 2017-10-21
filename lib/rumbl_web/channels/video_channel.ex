defmodule RumblWeb.VideoChannel do
  use RumblWeb, :channel
  alias Rumbl.Repo
  alias RumblWeb.AnnotationView
  import Ecto.Query
  import Ecto

  def join("videos:" <> video_id, _params, socket) do
    video_id = String.to_integer(video_id)
    video = Repo.get!(Rumbl.Contents.Video, video_id)
    annotations = Repo.all(from a in assoc(video, :annotations), order_by: [asc: a.at, asc: a.id], limit: 200, preload: [:user])
    resp = %{annotations: Phoenix.View.render_many(annotations, AnnotationView, "annotation.json")}

    {:ok, resp, assign(socket |> IO.inspect, :video_id, video_id)}
  end

  def handle_in(event, params, socket) do
    user = Repo.get(Rumbl.Accounts.User, socket.assigns.user_id)
    handle_in(event, params, user, socket)
  end

  def handle_in("new_annotation", params, user, socket) do
    changeset = user
    |> Ecto.build_assoc(:annotations, video_id: socket.assigns.video_id)
    |> Rumbl.Contents.Annotation.changeset(params)

    case Repo.insert(changeset) do
      {:ok, annotation} ->
        broadcast! socket, "new_annotation", %{
          id: annotation.id,
          user: RumblWeb.UserView.render("user.json", %{user: user}),
          body: annotation.body,
          at: annotation.at,
        }
        {:reply, :ok, socket}
      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end

  end
end
