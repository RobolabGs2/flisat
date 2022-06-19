defmodule Flisat.Content.Post.Test do
  use Flisat.DataCase

  alias Flisat.Content

  test "delete_post/1 test" do
    post = insert(:post)
    assert {:ok, _result} = Content.delete_post(post)
    assert {:error, :not_found} = Content.get_post(post.id)
  end

  test "update_post/2 title test" do
    post = insert(:post, %{title: "Old title"})
    attrs = %{title: "New title"}
    assert {:ok, updated_post} = Content.update_post(post, attrs)
    assert updated_post.title == attrs.title
  end

  test "create_post/1 validation title lenght test" do
    assert {:error, _changeset} =
             Content.create_post(%{
               title: Faker.String.base64(257),
               content: Faker.Lorem.sentence(4..8),
               author_id: insert(:user).id
             })
  end

  test "create_post/1 validation author does not exists test" do
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

  test "create_post/1 with tags test" do
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

  test "list_posts/1 with filter by author" do
    author = insert(:user)

    author_posts = [
      insert(:post, %{author: author}).id,
      insert(:post, %{author: author}).id,
      insert(:post, %{author: author}).id
    ]
    insert(:post)
    insert(:post)
    insert(:post)
    insert(:post)
    posts = Content.list_posts(%{author_id: author.id})
    assert equals_as_sets(Enum.map(posts.entries, fn p -> p.id end), author_posts)
  end

  test "list_posts/1 with filter by title" do
    expected_posts = [
      insert(:post, %{title: "Elixir tutorial #1. Hello there!"}).id,
      insert(:post, %{title: "Elixir tutorial #2"}).id,
      insert(:post, %{title: "Next Elixir tutorial #3"}).id
    ]
    insert(:post, %{title: "Go tutorial #42"})
    insert(:post, %{title: "You search another post"})
    insert(:post, %{title: "Elixir shoulds not pass!"})
    insert(:post, %{title: "Example title"})
    posts = Content.list_posts(%{title: "Elixir tutorial"})
    assert equals_as_sets(Enum.map(posts.entries, fn p -> p.id end), expected_posts)
  end

  test "list_posts/1 with filter by content" do
    expected_posts = [
      insert(:post, %{content: "Elixir tutorial #1. Hello there!"}).id,
      insert(:post, %{content: "Elixir tutorial #2"}).id,
      insert(:post, %{content: "Next Elixir tutorial #3"}).id
    ]
    insert(:post, %{content: "Go tutorial #42"})
    insert(:post, %{content: "You search another post"})
    insert(:post, %{content: "Elixir shoulds not pass!"})
    insert(:post, %{content: "Example title"})
    posts = Content.list_posts(%{content: "Elixir tutorial"})
    assert equals_as_sets(Enum.map(posts.entries, fn p -> p.id end), expected_posts)
  end

  defp equals_as_sets(list1, list2) do
    length(list1 -- list2) == 0 and length(list2 -- list1) == 0
  end
end
