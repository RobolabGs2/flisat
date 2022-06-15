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

  test "delete_post/1 test" do
    post = insert(:post)
    assert {:ok, _result} = Content.delete_post(post)
    assert {:error, :not_found} = Content.get_post(post.id)
  end

  test "update_post/1 title test" do
    post = insert(:post, %{title: "Old title"})
    attrs = %{title: "New title"}
    assert {:ok, updated_post} = Content.update_post(post, attrs)
    assert updated_post.title == attrs.title
  end

  test "create_post/2 validation title lenght test" do
    assert {:error, _changeset} =
             Content.create_post(%{
               title: Faker.String.base64(257),
               content: Faker.Lorem.sentence(4..8),
               author_id: insert(:user).id
             })
  end

  test "create_post/2 validation author does not exists test" do
    assert {:error,
            %Ecto.Changeset{
              errors: [author: {"does not exist", _ignore}],
              action: _action,
              changes: _changes,
              valid?: false
            }} =
             Content.create_post(%{
               title: Faker.Lorem.sentence(1..3),
               content: Faker.Lorem.sentence(4..8),
               author_id: -1
             })
  end
end
