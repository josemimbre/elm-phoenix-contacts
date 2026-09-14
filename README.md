![Elixir CI](https://github.com/josemimbre/elm-phoenix-contacts/workflows/Elixir%20CI/badge.svg)

# Contacts

A contacts directory app: a [Phoenix](https://www.phoenixframework.org/) backend serving a
[Elm](https://elm-lang.org/) single-page frontend, with a paginated, searchable REST API and a
Phoenix Channel for real-time updates.

## Stack

- **Backend**: Phoenix 1.8, Elixir ~1.20, MySQL (via Ecto/MyXQL), served by Bandit
- **Frontend**: Elm 0.19, bundled with webpack (Stylus for CSS, no Tailwind/esbuild)
- **API**: REST JSON at `/api/v1/contacts` (paginated, searchable), plus a `"contacts"` Phoenix
  Channel for real-time fetches
- **Dev tooling**: Docker Compose (MySQL), a `Makefile` for common tasks, Phoenix LiveDashboard

## Prerequisites

- [asdf](https://asdf-vm.com/) is recommended to match the exact toolchain versions pinned in
  `~/.tool-versions` / this repo: Elixir 1.20, Erlang/OTP 29, Elm 0.19.1
- [Node.js](https://nodejs.org/) (for the webpack asset build)
- [Docker](https://www.docker.com/) (for the local MySQL database)

## Getting started

```sh
make setup   # fetch deps, start the db, create/migrate/seed it, build assets
make server  # start the Phoenix server at http://localhost:4000
```

Run `make help` to see every available task (`db-up`/`db-down`, `console`, `test`, `format`,
`precommit`, `assets-watch`, `reset`, ...).

Without `make`, the equivalent steps are:

```sh
mix deps.get
docker compose up -d          # starts MySQL on localhost:3306
mix ecto.setup                # create, migrate and seed the database
mix assets.setup              # npm install
mix assets.build              # one-off webpack build
mix phx.server                # starts the server and the asset watcher
```

Visit [`localhost:4000`](http://localhost:4000) for the app, and
[`localhost:4000/dev/dashboard`](http://localhost:4000/dev/dashboard) for
[Phoenix LiveDashboard](https://hexdocs.pm/phoenix_live_dashboard) (dev only).

## Testing

```sh
make test   # or: mix test
```

Runs against MySQL too (via `Ecto.Adapters.SQL.Sandbox`), so the database container needs to be
up first (`make db-up`).

## Project layout

- `lib/contacts/` — the `Contacts.Main` context (contacts CRUD, search, pagination) and Ecto schema
- `lib/contacts_web/` — controllers, the `PageHTML`/`Layouts` HEEx modules, the JSON API, and the
  `"contacts"` channel
- `assets/elm/` — the Elm application (`Main.elm` handles routing between the contact list and
  detail pages)
- `assets/` — webpack config and the rest of the JS/CSS build pipeline
- `compose.yml` — local MySQL for development (also used by CI)

## CI

GitHub Actions (`.github/workflows/elixir.yml`) runs the test suite (including a full asset
build) on every push, plus a [zizmor](https://docs.zizmor.sh/) scan of the workflows themselves,
reported under the repo's Security → Code scanning tab.

## Deploying

This app uses `config/runtime.exs` for release configuration. At minimum, a production release
needs `DATABASE_URL`, `SECRET_KEY_BASE` (generate with `mix phx.gen.secret`), `PHX_HOST`, and
`PHX_SERVER=true` set in the environment. See the
[Phoenix deployment guides](https://hexdocs.pm/phoenix/deployment.html) for the rest.
