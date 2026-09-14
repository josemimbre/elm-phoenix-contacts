defmodule ContactsWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use ContactsWeb, :html

  embed_templates "layouts/*"

  @doc """
  Renders the app layout.

  ## Examples

      <Layouts.app flash={@flash}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <p :if={Phoenix.Flash.get(@flash, :info)} class="alert alert-info" role="alert">
      {Phoenix.Flash.get(@flash, :info)}
    </p>
    <p :if={Phoenix.Flash.get(@flash, :error)} class="alert alert-danger" role="alert">
      {Phoenix.Flash.get(@flash, :error)}
    </p>
    {render_slot(@inner_block)}
    """
  end
end
