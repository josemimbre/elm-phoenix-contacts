defmodule ContactsWeb.Api.V1.ContactController do
  use ContactsWeb, :controller

  def index(conn, params) do
    contacts = Contacts.Main.list_contacts_page(:first_name, page: params["page"])

    render(conn, "index.json",
      contacts: contacts.entries,
      page_number: contacts.page_number,
      page_size: contacts.page_size,
      total_pages: contacts.total_pages,
      total_entries: contacts.total_entries
    )
  end
end
