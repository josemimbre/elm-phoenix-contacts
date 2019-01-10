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
  def list_contacts_page(
        %{page: _page} = paginate_params,
        search_query
      ) do
    Contact
    |> search_contact(search_query)
    |> order_by(:first_name)
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

  defp search_contact(query, ""), do: query

  defp search_contact(query, search_query) do
    search_query = format_contact_query(search_query)

    query
    |> where(
      fragment(
        """
        MATCH (first_name, last_name, location, headline, email, phone_number)
        AGAINST (? IN NATURAL LANGUAGE MODE)
        """,
        ^search_query
      )
    )
  end

  defp format_contact_query(search_query) do
    search_query
    |> String.trim()
    |> String.split(" ")
    |> Enum.map(&"+#{&1}")
    |> Enum.join(" ")
  end
end
