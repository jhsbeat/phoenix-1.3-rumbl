defmodule RumblWeb.AuthTest do
  use RumblWeb.ConnCase
  alias RumblWeb.Auth

  test "authenticate_user halts when no current_user exists", %{conn: conn} do
    conn = Auth.authenticate_user(conn, [])
    assert conn.halted
  end

  test "authenticate_user continues when the current_user exists", %{conn: conn} do
    conn = conn
    |> assign(:current_user, %Rumbl.Accounts.User{})
    |> Auth.authenticate_user([])
    refute conn.halted
  end
end
