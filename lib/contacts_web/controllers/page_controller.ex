defmodule ContactsWeb.PageController do
  use ContactsWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
