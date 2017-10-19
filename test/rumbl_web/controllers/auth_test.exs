defmodule RumblWeb.AuthTest do
  use RumblWeb.ConnCase
  alias RumblWeb.Auth

  setup %{conn: conn} do
    conn = conn
    |> bypass_through(RumblWeb.Router, :browser) # session, flash 등을 fetch 하기 위해 router dispatch 직전까지 진행하도록 설정.
    |> get("/") # dispatch 직전까지 진행하여, session, flash fetch.
    {:ok, %{conn: conn}}
  end

  test "authenticate_user halts when no current_user exists", %{conn: conn} do
    conn = conn |> Auth.authenticate_user([])
    assert conn.halted
  end

  test "authenticate_user continues when the current_user exists", %{conn: conn} do
    conn = conn
    |> assign(:current_user, %Rumbl.Accounts.User{}) # Auth.call 에서 nil 로 설정된 것을 %User{} 로 덮어 씀.
    |> Auth.authenticate_user([])
    refute conn.halted
  end

  test "login puts the user in the session", %{conn: conn} do
    conn = conn
    |> Auth.login(%Rumbl.Accounts.User{id: 123})
    assert get_session(conn, :user_id) == 123
  end

  test "logout drops the session", %{conn: conn} do
    conn = conn
    |> put_session(:user_id, 123)
    |> Auth.logout()
    assert conn.private.plug_session_info == :drop
  end
end
