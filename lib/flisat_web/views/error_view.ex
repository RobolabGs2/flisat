defmodule FlisatWeb.ErrorView do
  use FlisatWeb, :view

  alias Ecto.Changeset
  alias Flisat.Accounts.Error

  def render("404.json", %{}) do
    %{errors: ["Not found"]}
  end

  def render("403.json", %{message: message}) do
    %{errors: [message]}
  end

  def render("401.json", %{error: %Error{} = error}) do
    %{errors: [Map.from_struct(error)]}
  end

  def render("422.json", %{changeset: %Changeset{errors: errors}}) do
    %{errors: convert_errors(errors)}
  end

  defp convert_errors(errors) do
    Enum.map(errors, fn {field, {details, _details}} ->
      %{field: field, code: details}
    end)
  end

  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
