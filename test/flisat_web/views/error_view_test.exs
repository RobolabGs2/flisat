defmodule FlisatWeb.ErrorViewTest do
  use FlisatWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.json" do
    assert render(FlisatWeb.ErrorView, "404.json", []) == %{errors: ["Not found"]}
  end

  test "renders 500.json" do
    assert render(FlisatWeb.ErrorView, "500.json", []) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
