defmodule BenarID.MemberSchemaTest do
  use ExUnit.Case

  alias BenarID.Schema.Member

  @valid_attrs %{name: "Foo Bar", email: "email@example.com"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Member.changeset(%Member{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Member.changeset(%Member{}, @invalid_attrs)
    refute changeset.valid?
  end
end
