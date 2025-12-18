# SigninappEx ✅

**SigninappEx** is a small Elixir-based microservice that implements user signup and signin flows using a simple Domain-Driven style and in-memory persistence (ETS).

This project follows the programming manifesto provided by the team (see the 'Programming Manifesto' link below) and is intended as a sample / starter for authentication flows implemented in Elixir.

---

## 🚀 Key features

- Sign-up (POST /api/signup) — accepts JSON with `email`, `password`, and optional `name` and returns **201 Created** on success.
- Sign-in (POST /api/signin) — accepts JSON with `email` and `password` and returns **200 OK** with `{ "session_id": "<uuid>" }` on success.
- Health check (`/api/health`) backed by `PlugCheckup`.
- Test coverage and simple in-memory driver adapters (ETS) for easy local development.

## 🏗️ Architecture overview

- Domain: `lib/domain/*` contains DTOs and UseCases (`SignupUseCase`, `SigninUseCase`).
- Infrastructure:
  - Entry points: HTTP/Plug controllers in `lib/infrastructure/entry_points/rest_controller/*` (Router, SignupHandler, SigninHandler).
  - Driven adapters: `lib/infrastructure/driven_adapters/localstorage/*` uses ETS via `UserStore` for persistence.
- Responses follow a structured format via `ResponseSuccessController` and `ResponseErrorController` and include `message-id` / `x-request-id` headers.

## 🔧 Requirements

- Elixir ~> 1.13
- Erlang/OTP compatible with the Elixir version

## 📦 Setup & running locally

1. Install dependencies:

   ```bash
   mix deps.get
   ```

2. Run tests:

   ```bash
   mix test
   ```

3. Start the server (default dev port: 8083):

   ```bash
   MIX_ENV=dev mix run --no-halt
   ```

   By default `config/dev.exs` sets `enable_server: true` and `http_port: 8083`. Change those values in `config/*.exs` as needed.

## 🔁 API Examples

- Sign-up

  ```bash
  curl -s -X POST http://localhost:8083/api/signup \
    -H "Content-Type: application/json" \
    -d '{"email":"user@example.com","password":"My$tr0ngP@ss","name":"Andrés"}' -v
  # returns 201 Created (empty body)
  ```

- Sign-in

  ```bash
  curl -s -X POST http://localhost:8083/api/signin \
    -H "Content-Type: application/json" \
    -d '{"email":"user@example.com","password":"My$tr0ngP@ss"}' -v
  # returns 200 OK with JSON: {"session_id":"<uuid>"}
  ```

- Health check

  ```bash
  curl http://localhost:8083/api/health
  ```

## 🧪 Tests & coverage

- Run unit tests: `mix test`
- Generate coverage (excoveralls is configured): `mix coveralls.html` (requires excoveralls in `:test` env)

## 🗂️ Configuration

Main application options are in `config/*.exs`:
- `:http_port` — default 8083
- `:enable_server` — start HTTP server when true
- Gateway implementations (dev/test) are wired in `config/dev.exs` and `config/test.exs` to local storage adapters.

## 📌 Notes & next steps

- Persistence is in-memory ETS (convenient for tests and local development). Replace the local storage adapters with a DB adapter for production.
- The project currently does not include a `LICENSE` file — add a license if this repo will be publicly distributed.
- Consider adding CI (GitHub Actions) and a small OpenAPI spec for the HTTP API.

## 📚 Reference
- Programming manifesto used as guideline: [Manifesto de programación (Elixir)](https://bancolombia.sharepoint.com.mcas.ms/:w:/r/teams/EVC2.0AUTENTICACINYMONITOREO/_layouts/15/doc2.aspx?sourcedoc=%7B69DC9D32-5F22-466C-AFAC-283B55ADD4E1%7D&file=Manifiesto-programacion-%20elixir-v1.docx&fromShare=true&action=default&mobileredirect=true)

---

If you'd like, I can also:
- Add an example `docker-compose` or Dockerfile usage snippet, or
- Add a `LICENSE` file (MIT/Apache) and CI workflow (GitHub Actions) — tell me which one and I can create it.
