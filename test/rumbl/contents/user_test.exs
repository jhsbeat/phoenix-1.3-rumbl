defmodule Rumbl.Contents.UserTest do
  use Rumbl.DataCase, async: true
  alias Rumbl.Accounts.User

  @valid_attrs %{name: "A User", username: "eva", password: "secret"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset does not accept long usernames" do
    attrs = Map.put(@valid_attrs, :username, String.duplicate("a", 30))
    changeset = User.changeset(%User{}, attrs)
    assert "should be at most 20 character(s)" in errors_on(changeset).username
  end
end
