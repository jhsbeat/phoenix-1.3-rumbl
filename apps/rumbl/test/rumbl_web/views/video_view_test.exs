defmodule RumblWeb.VideoViewTest do
  use RumblWeb.ConnCase, async: true
  import Phoenix.View
  alias Rumbl.Contents

  test "renders index.html", %{conn: conn} do
    videos = [%Contents.Video{id: "1", title: "dogs"},
              %Contents.Video{id: "2", title: "cars"}]
    content = render_to_string(RumblWeb.VideoView, "index.html", conn: conn, videos: videos)

    assert String.contains?(content, "Listing Videos")
    for video <- videos do
      assert String.contains?(content, video.title)
    end
  end

  test "renders new.html", %{conn: conn} do
    changeset = Contents.change_video(%Contents.Video{})
    categories = [{"cats", 123}]
    content = render_to_string(RumblWeb.VideoView, "new.html",
      conn: conn, changeset: changeset, categories: categories)

    assert String.contains?(content, "New Video")
  end
end
