defmodule ContactsWeb.Router do
  use ContactsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_root_layout, html: {ContactsWeb.Layouts, :root}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ContactsWeb, as: :api do
    pipe_through :api

    scope "/v1", Api.V1, as: :v1 do
      resources "/contacts", ContactController, only: [:index, :show]
    end
  end

  scope "/", ContactsWeb do
    pipe_through :browser

    get "/*path", PageController, :home
  end
end
