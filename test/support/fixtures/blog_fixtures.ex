defmodule Flisat.BlogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Flisat.Blog` context.
  """

  @doc """
  Generate a unique tag title.
  """
  def unique_tag_title, do: "some title#{System.unique_integer([:positive])}"

  @doc """
  Generate a tag.
  """
  def tag_fixture(attrs \\ %{}) do
    {:ok, tag} =
      attrs
      |> Enum.into(%{
        description: "some description",
        title: unique_tag_title()
      })
      |> Flisat.Blog.create_tag()

    tag
  end
end
