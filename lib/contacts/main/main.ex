defmodule Contacts.Main do
  @moduledoc """
  The Main context.
  """

  import Ecto.Query, warn: false
  alias Contacts.Repo

  alias Contacts.Main.Contact

  @doc """
  Returns the list of contacts.

  ## Examples

      iex> list_contacts()
      [%Contact{}, ...]

  """
  def list_contacts do
    Contact
    |> Repo.all()
  end

  @doc """
  Returns the list of contacts sorted.

  ## Examples

      iex> list_contacts()
      [%Contact{}, ...]

  """
  def list_contacts_page(order_param \\ :first_name, paginate_params) do
    IO.inspect(paginate_params)

    Contact
    |> order_by(asc: ^order_param)
    |> Repo.paginate(paginate_params)
  end

  @doc """
  Creates a contact.

  ## Examples

      iex> create_contact(%{field: value})
      {:ok, %Contact{}}

      iex> create_contact(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_contact(attrs \\ %{}) do
    %Contact{}
    |> Contact.changeset(attrs)
    |> Repo.insert()
  end
end
