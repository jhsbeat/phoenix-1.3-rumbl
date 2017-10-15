defmodule RumblWeb.VideoController do
  use RumblWeb, :controller

  alias Rumbl.Contents
  alias Rumbl.Contents.Video

  def index(conn, _params) do
    videos = Contents.list_videos()
    render(conn, "index.html", videos: videos)
  end

  def new(conn, _params) do
    changeset = conn.assigns.current_user
    |> Ecto.build_assoc(:videos)
    |> Contents.change_video()

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"video" => video_params}) do
    case Contents.create_video(video_params) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video created successfully.")
        |> redirect(to: video_path(conn, :show, video))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    video = Contents.get_video!(id)
    render(conn, "show.html", video: video)
  end

  def edit(conn, %{"id" => id}) do
    video = Contents.get_video!(id)
    changeset = Contents.change_video(video)
    render(conn, "edit.html", video: video, changeset: changeset)
  end

  def update(conn, %{"id" => id, "video" => video_params}) do
    video = Contents.get_video!(id)

    case Contents.update_video(video, video_params) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video updated successfully.")
        |> redirect(to: video_path(conn, :show, video))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", video: video, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    video = Contents.get_video!(id)
    {:ok, _video} = Contents.delete_video(video)

    conn
    |> put_flash(:info, "Video deleted successfully.")
    |> redirect(to: video_path(conn, :index))
  end
end
