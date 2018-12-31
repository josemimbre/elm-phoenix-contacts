defmodule ContactsWeb.ContactView do
  use ContactsWeb, :view

  def render("index.json", %{page: page}) do
    %{data: render_many(page, Teacher.Api.V1.MovieView, "movie.json")}
  end
end
