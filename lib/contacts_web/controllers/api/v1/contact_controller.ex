defmodule ContactsWeb.Api.V1.ContactController do
  use ContactsWeb, :controller

  alias Contacts.Main

  def index(conn, params) do
    page = params["page"]
    search = Map.get(params, "search", "")
    contacts = Main.list_contacts_page(%{page: page}, search)

    render(conn, "index.json",
      contacts: contacts.entries,
      page_number: contacts.page_number,
      page_size: contacts.page_size,
      total_pages: contacts.total_pages,
      total_entries: contacts.total_entries
    )
  end
end
