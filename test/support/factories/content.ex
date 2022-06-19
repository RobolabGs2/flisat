defmodule Flisat.Factories.Content do
  defmacro __using__(_opts) do
    quote do
      alias Flisat.Content.Tag
      alias Flisat.Content.Post
      alias Flisat.Content.Comment
      alias Flisat.Accounts.User
      alias Faker.Lorem

      def tag_factory(attrs) do
        title = Map.get(attrs, :title, sequence(:title, &"#{&1}_#{Lorem.words(1..2)}"))
        description = Map.get(attrs, :description, Lorem.sentence(1..16))

        %Ecto.Changeset{valid?: true, changes: changes} =
          Tag.changeset(%Tag{}, %{
            title: title,
            description: description
          })

        struct(%Tag{}, changes)
      end

      def post_factory(attrs) do
        title = Map.get(attrs, :title, sequence(:title, &"#{&1}_#{Lorem.sentence(1..4)}"))
        content = Map.get(attrs, :content, Lorem.sentences(4..16) |> Enum.join(" "))
        author = Map.get(attrs, :author, insert(:user))

        %Ecto.Changeset{valid?: true, changes: changes} =
          Post.changeset(%Post{}, %{
            title: title,
            content: content,
            author_id: author.id
          })

        struct(%Post{}, changes)
      end

      def comment_factory(attrs) do
        content = Map.get(attrs, :content, Lorem.sentences(1..16) |> Enum.join(" "))
        author = Map.get(attrs, :author, insert(:user))
        post = Map.get(attrs, :post, insert(:post))

        %Ecto.Changeset{valid?: true, changes: changes} =
          Comment.changeset(%Comment{}, %{
            content: content,
            author_id: author.id,
            post_id: post.id
          })

        struct(%Comment{}, changes)
      end
    end
  end
end
