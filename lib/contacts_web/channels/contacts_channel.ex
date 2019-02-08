defmodule ContactsWeb.ContactsChannel do
  use ContactsWeb, :channel

  alias Contacts.Main
  require Logger

  def join("contacts", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("contacts:fetch", params, socket) do
    Logger.info("Handling contacts...")
    page = params["page"]
    search = Map.get(params, "search", "")
    contacts = Main.list_contacts_page(%{page: page}, search)

    {:reply,
     {:ok,
      %{
        contacts: contacts.entries,
        page_number: contacts.page_number,
        page_size: contacts.page_size,
        total_pages: contacts.total_pages,
        total_entries: contacts.total_entries
      }}, socket}
  end

  def handle_in("contact:" <> contact_id, _, socket) do
    Logger.info("Handling contact...")
    contact = Main.get_contact!(contact_id)

    case contact do
      nil ->
        {:reply, {:error, %{error: "Contact no found"}}, socket}

      _ ->
        {:reply, {:ok, %{contact: contact}}, socket}
    end
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
