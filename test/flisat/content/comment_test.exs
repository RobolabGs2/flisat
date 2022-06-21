defmodule Flisat.Content.Comments.Test do
  use Flisat.DataCase

  alias Flisat.Content

  test "delete_comment/1 test" do
    comment = insert(:comment)
    assert {:ok, _result} = Content.delete_comment(comment)
    assert {:error, :not_found} = Content.get_comment(comment.id)
  end

  test "update_comment/2 content test" do
    comment = insert(:comment, %{content: "Old comment"})
    attrs = %{content: "New comment"}
    assert {:ok, updated_comment} = Content.update_comment(comment, attrs)
    assert updated_comment.content == attrs.content
    assert updated_comment.author_id == comment.author_id
    assert updated_comment.post_id == comment.post_id
  end

  test "create_comment/1 validation author does not exists test" do
    assert {:error,
            %Ecto.Changeset{
              errors: [author: {"does not exist", _ignore}],
              action: _action,
              changes: _changes,
              valid?: false
            }} =
             Content.create_comment(%{
               content: Faker.Lorem.sentence(4..8),
               author_id: -1,
               post_id: insert(:post).id
             })
  end

  test "create_comment/1 validation post does not exists test" do
    assert {:error,
            %Ecto.Changeset{
              errors: [post: {"does not exist", _ignore}],
              action: _action,
              changes: _changes,
              valid?: false
            }} =
             Content.create_comment(%{
               content: Faker.Lorem.sentence(4..8),
               author_id: insert(:user).id,
               post_id: -1
             })
  end

  test "like_comment/2 like" do
    comment = insert(:comment)
    user = insert(:user)
    {:ok, _} = Content.like_comment(comment, user)
    comment_likes = Flisat.Repo.preload(comment, :likes).likes
    assert length(comment_likes) == 1
    assert user.id in Enum.map(comment_likes, fn user -> user.id end)
    user_likes = Flisat.Repo.preload(user, :comments_likes).comments_likes
    assert comment.id in Enum.map(user_likes, fn comment -> comment.id end)
  end

  test "like_comment/2 can't like to comment that does't exist " do
    assert {:error, _msg} = Content.like_comment(%Content.Comment{id: -1}, insert(:user))
  end

  test "like_comment/2 can't like by user that does't exist " do
    assert {:error, _msg} = Content.like_comment(insert(:comment), %Flisat.Accounts.User{id: -1})
  end
end
