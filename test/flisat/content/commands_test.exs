defmodule Flisat.Content.Commands.Test do
  use Flisat.DataCase

  alias Flisat.Content

  test "delete_tag/1 test" do
    tag = insert(:tag)
    assert {:ok, _result} = Content.delete_tag(tag)
    assert {:error, :not_found} = Content.get_tag(tag.id)
  end

  test "update_tag/1 test" do
    tag = insert(:tag, %{title: "Old title"})
    attrs = %{title: "New title"}
    assert {:ok, updated_tag} = Content.update_tag(tag, attrs)
    assert updated_tag.title == attrs.title
  end
end
