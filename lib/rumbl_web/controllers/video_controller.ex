defmodule RumblWeb.VideoController do
  use RumblWeb, :controller

  alias Rumbl.Category
  alias Rumbl.Contents
  alias Rumbl.Contents.{Category, Video}

  plug :load_categories when action in [:new, :create, :edit, :update]

  defp load_categories(conn, _) do
    categories =
      Category
      |> Category.alphabetical()
      |> Category.names_and_ids()
      |> Repo.all()
    assign(conn, :categories, categories)
  end

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, user) do
    videos = user |> Contents.user_videos()
    render(conn, "index.html", videos: videos)
  end

  def new(conn, _params, _user) do
    render(conn, "new.html", changeset: Contents.change_video(%Video{}))
  end

  def create(conn, %{"video" => video_params}, user) do
    case Contents.create_video(Map.put(video_params, "user_id", user.id)) do
      {:ok, _video} ->
        conn
        |> put_flash(:info, "Video created successfully.")
        |> redirect(to: video_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, user) do
    video = Contents.user_video!(user, id)
    render(conn, "show.html", video: video)
  end

  def edit(conn, %{"id" => id}, user) do
    video = Contents.user_video!(user, id)
    changeset = Contents.change_video(video)
    render(conn, "edit.html", video: video, changeset: changeset)
  end

  def update(conn, %{"id" => id, "video" => video_params}, user) do
    video = Contents.user_video!(user, id)

    case Contents.update_video(video, video_params) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video updated successfully.")
        |> redirect(to: video_path(conn, :show, video))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", video: video, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, user) do
    video = Contents.user_video!(user, id)
    {:ok, _video} = Contents.delete_video(video)

    conn
    |> put_flash(:info, "Video deleted successfully.")
    |> redirect(to: video_path(conn, :index))
  end
end
