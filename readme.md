# ASCII canvas

# Server

For simplicity, there is an assumption that (in dev and test mode) you're running the server
on a machine with PostgreSQL server installed and listening on the default port (5432).
It should allow "trust" authentication with your current system user, which is the default behavior.
Should this assumption not apply, you need to specify your database connection properties
in the `server/config/dev.exs` file.

To start the server:
  * Go to the `server` folder
  * Install dependencies with `mix deps.get`
  * Create and migrate the database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can send requests to [`localhost:4000`](http://localhost:4000) from the client.

To run the tests:
  * Go to the `server` folder
  * Install dependencies with `mix deps.get`
  * Create and migrate the database with `mix ecto.setup`
  * Run `mix test`

# Client

By default, the client expects the server to be available at `http://localhost:4000`.
Should you need the server to be at a different location, please,
specify it in the environment variable `CANVAS_SERVER_URL`.

To use the client:
  * Go to the `client` folder
  * Install dependencies with `mix deps.get`
  * Build the binary file with ``./build.sh`
  * Render a canvas with `./canvas_client render 9304172c-baa5-4333-ba9e-3d6f0d93348b`

To run the tests:
  * Go to the `client` folder
  * Install dependencies with `mix deps.get`
  * Run `mix test`
