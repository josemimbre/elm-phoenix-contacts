defmodule ContactsWeb.PageController do
  use ContactsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
