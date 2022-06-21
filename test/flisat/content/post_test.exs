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
               tags: [tag1, tag2]
             })

    assert {:ok, post2} =
             Content.create_post(%{
               title: Faker.Lorem.sentence(1..4),
               content: Faker.Lorem.sentence(1..4),
               author_id: insert(:user).id,
               tags: [tag1]
             })

    assert {:ok, post3} =
             Content.create_post(%{
               title: Faker.Lorem.sentence(1..4),
               content: Faker.Lorem.sentence(1..4),
               author_id: insert(:user).id,
               tags: [tag2]
             })

    tag1postIds = (tag1 |> Flisat.Repo.preload(:posts)).posts |> extract_id()
    assert post1.id in tag1postIds
    assert post2.id in tag1postIds
    assert post3.id not in tag1postIds

    tag2postIds = (tag2 |> Flisat.Repo.preload(:posts)).posts |> extract_id()
    assert post1.id in tag2postIds
    assert post2.id not in tag2postIds
    assert post3.id in tag2postIds
  end

  test "list_posts/1 with filter by author" do
    author = insert(:user)
    author_posts = insert_list(3, :post, %{author: author}) |> Enum.map(fn p -> p.id end)
    insert_list(4, :post)

    posts = Content.list_posts(%{author_id: author.id})
    assert equals_as_sets(extract_id(posts.entries), author_posts)
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
    assert equals_as_sets(extract_id(posts.entries), expected_posts)
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
    insert(:post, %{content: "Example content"})
    posts = Content.list_posts(%{content: "Elixir tutorial"})
    assert equals_as_sets(extract_id(posts.entries), expected_posts)
  end

  test "list_posts/1 with filter by tags with one tag" do
    [tag1, tag2, tag3] = insert_list(3, :tag)
    posts_with_tag1 = insert_list(4, :post) |> add_tags([tag1])
    posts_with_tag1_and_another = insert_list(2, :post) |> add_tags([tag2, tag1])
    _posts_without_tag1 = insert_list(5, :post) |> add_tags([tag2, tag3])

    posts = Content.list_posts(%{tag_ids: [tag1.id]})

    assert equals_as_sets(
             extract_id(posts.entries),
             extract_id(posts_with_tag1 ++ posts_with_tag1_and_another)
           )
  end

  test "list_posts/1 with filter by tags with many tags" do
    [tag1, tag2, tag3] = insert_list(3, :tag)
    _posts_with_tag1 = insert_list(4, :post) |> add_tags([tag1])
    posts_with_tag1_and_tag2 = insert_list(2, :post) |> add_tags([tag2, tag1])
    _posts_without_tag1 = insert_list(5, :post) |> add_tags([tag2, tag3])

    posts = Content.list_posts(%{tag_ids: [tag1.id, tag2.id]})

    assert equals_as_sets(
             extract_id(posts.entries),
             extract_id(posts_with_tag1_and_tag2)
           )
  end

  test "list_posts/1 with filter by today date" do
    fresh_posts = insert_list(4, :post)
    today = DateTime.now!("Etc/UTC") |> DateTime.to_date()
    posts = Content.list_posts(%{start_date: today, end_date: today})

    assert equals_as_sets(
             extract_id(posts.entries),
             extract_id(fresh_posts)
           )
  end

  test "list_posts/1 with filter by tommorow date" do
    _fresh_posts = insert_list(4, :post)
    tommorow = DateTime.now!("Etc/UTC") |> DateTime.to_date() |> Date.add(1)
    posts = Content.list_posts(%{start_date: tommorow, end_date: tommorow})
    assert posts.total_entries == 0
  end

  test "list_posts/1 with filter by rating" do
    posts_with_2_likes = insert_list(1, :post) |> add_likes(2)
    posts_with_4_likes = insert_list(4, :post) |> add_likes(4)
    posts_with_10_likes = insert_list(1, :post) |> add_likes(10)

    posts_between_3_5 = Content.list_posts(%{min_likes: 3, max_likes: 5})

    assert equals_as_sets(
             extract_id(posts_between_3_5.entries),
             extract_id(posts_with_4_likes)
           )

    posts_between_2_5 = Content.list_posts(%{min_likes: 2, max_likes: 5})

    assert equals_as_sets(
             extract_id(posts_between_2_5.entries),
             extract_id(posts_with_2_likes ++ posts_with_4_likes)
           )

    posts_between_2_600 = Content.list_posts(%{min_likes: 2, max_likes: 600})

    assert equals_as_sets(
             extract_id(posts_between_2_600.entries),
             extract_id(posts_with_2_likes ++ posts_with_4_likes ++ posts_with_10_likes)
           )
  end

  test "like_post/2 like" do
    post = insert(:post)
    user = insert(:user)
    {:ok, _} = Content.like_post(post, user)
    post_likes = Flisat.Repo.preload(post, :likes).likes
    assert length(post_likes) == 1
    assert user.id in Enum.map(post_likes, fn user -> user.id end)
    user_likes = Flisat.Repo.preload(user, :posts_likes).posts_likes
    assert post.id in Enum.map(user_likes, fn post -> post.id end)
  end

  test "like_post/2 can't like to post that does't exist " do
    assert {:error, _msg} = Content.like_post(%Content.Post{id: -1}, insert(:user))
  end

  test "like_post/2 can't like by user that does't exist " do
    assert {:error, _msg} = Content.like_post(insert(:post), %Flisat.Accounts.User{id: -1})
  end

  defp equals_as_sets(list1, list2) do
    length(list1 -- list2) == 0 and length(list2 -- list1) == 0
  end

  defp extract_id(list) do
    Enum.map(list, fn p -> p.id end)
  end

  defp add_tags(posts, tags) when is_list(posts) do
    Enum.map(posts, fn post -> add_tags(post, tags) end)
  end

  defp add_tags(post, tags) do
    {:ok, post} = Content.update_post(post, %{tags: tags})
    post
  end

  defp add_likes(posts, count) when is_list(posts) do
    Enum.map(posts, fn post -> add_likes(post, count) end)
  end

  defp add_likes(post, count) do
    insert_list(count, :user)
    |> Enum.each(fn user -> Content.like_post(post, user) end)

    post
  end
end
