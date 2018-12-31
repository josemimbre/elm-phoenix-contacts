defmodule ContactsWeb.Api.V1.ContactController do
  use ContactsWeb, :controller

  alias Contacts.Contact
  alias Contacts.Repo

  import Ecto.Query, warn: false

  def index(conn, params) do
    page =
      Repo.all(
        from c in Contact,
          order_by: c.first_name
      )
      |> Repo.paginate(params)

    render(conn, "index.json", page: page)
  end
end
