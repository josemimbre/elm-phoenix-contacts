defmodule Contacts.Repo.Migrations.CreateGinIndexForContacts do
  use Ecto.Migration

  def change do
    execute """
      ALTER TABLE contacts ADD FULLTEXT (first_name, last_name, location, headline, email, phone_number);
    """
  end
end
