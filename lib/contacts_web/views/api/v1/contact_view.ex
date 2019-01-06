defmodule ContactsWeb.Api.V1.ContactView do
  use ContactsWeb, :view

  def render("index.json", %{
        contacts: contacts,
        page_number: page_number,
        page_size: page_size,
        total_pages: total_pages,
        total_entries: total_entries
      }) do
    %{
      entries: contacts,
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages
    }
  end
end
