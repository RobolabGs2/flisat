defmodule Flisat.Content do
  alias Flisat.Content.Commands
  alias Flisat.Content.Queries

  # Commands
  defdelegate create_tag(attrs), to: Commands, as: :create_tag
  defdelegate delete_tag(tag), to: Commands, as: :delete_tag
  defdelegate update_tag(tag, attrs), to: Commands, as: :update_tag

  # Queries
  defdelegate get_tag(id), to: Queries, as: :get_tag
  defdelegate list_tags(), to: Queries, as: :list_tags
end
