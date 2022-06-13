defmodule Flisat.Factories.Content do
  defmodule TagFactory do
    defmacro __using__(_opts) do
      quote do
        alias Flisat.Content.Tag
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
      end
    end
  end
end
