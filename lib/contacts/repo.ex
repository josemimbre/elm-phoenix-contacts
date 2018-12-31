defmodule Contacts.Repo do
  use Ecto.Repo,
    otp_app: :contacts,
    adapter: Ecto.Adapters.MySQL

  use Scrivener,
    page_size: 9
end
