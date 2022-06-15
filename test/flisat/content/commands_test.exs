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

  test "create_post/2 with tags test" do
    tag1 = insert(:tag)
    tag2 = insert(:tag)

    assert {:ok, post1} =
             Content.create_post(%{
               title: Faker.Lorem.sentence(1..4),
               content: Faker.Lorem.sentence(1..4),
               author_id: insert(:user).id,
               tag_ids: [tag1.id, tag2.id]
             })

    assert {:ok, post2} =
             Content.create_post(%{
               title: Faker.Lorem.sentence(1..4),
               content: Faker.Lorem.sentence(1..4),
               author_id: insert(:user).id,
               tag_ids: [tag1.id]
             })

    assert {:ok, post3} =
             Content.create_post(%{
               title: Faker.Lorem.sentence(1..4),
               content: Faker.Lorem.sentence(1..4),
               author_id: insert(:user).id,
               tag_ids: [tag2.id]
             })

    # TODO think about it again
    tag1postIds = (tag1 |> Flisat.Repo.preload(:posts)).posts |> Enum.map(fn post -> post.id end)
    assert post1.id in tag1postIds
    assert post2.id in tag1postIds
    assert post3.id not in tag1postIds

    tag2postIds = (tag2 |> Flisat.Repo.preload(:posts)).posts |> Enum.map(fn post -> post.id end)
    assert post1.id in tag2postIds
    assert post2.id not in tag2postIds
    assert post3.id in tag2postIds
  end
end
