defmodule Flisat.Factories.Accounts.UserFactory do
  defmacro __using__(_opts) do
    quote do
      alias Flisat.Accounts.User
      alias Faker.{Internet, Lorem}

      def user_factory(attrs) do
        password = Map.get(attrs, :password, "#{Lorem.words(4..6)}Aa1")

        nickname = Map.get(attrs, :nickname, Internet.user_name())

        %Ecto.Changeset{valid?: true, changes: changes} =
          User.changeset(%User{}, %{
            password: password,
            nickname: sequence(:nickname, &"#{&1}_#{nickname}")
          })

        struct(%User{}, changes)
      end
    end
  end
end
