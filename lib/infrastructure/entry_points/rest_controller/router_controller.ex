defmodule SigninappEx.Infrastructure.EntryPoints.RestController.RouterController do
  @compile if Mix.env() == :test, do: :export_all
  @moduledoc """
  Access point to the rest exposed services
  """
  # alias SigninappEx.Utils.DataTypeUtils
  require Logger
  use Plug.Router
  use Timex

  plug(CORSPlug,
    methods: ["GET", "POST", "PUT", "DELETE"],
    origin: [~r/.*/],
    headers: ["Content-Type", "Accept", "User-Agent"]
  )

  plug(Plug.Logger, log: :debug)
  plug(:match)
  plug(Plug.Parsers, parsers: [:urlencoded, :json], json_decoder: Poison)
  plug(Plug.Telemetry, event_prefix: [:signinapp_ex, :plug])
  plug(:dispatch)

  @path_signup "/api/signup"
  @path_signin "/api/signin"

  forward(
    "/api/health",
    to: PlugCheckup,
    init_opts:
      PlugCheckup.Options.new(
        json_encoder: Jason,
        checks:
          SigninappEx.Infrastructure.EntryPoints.RestController.Shared.Common.Application.HealthCheck.checks()
      )
  )

  get "/api/hello" do
    build_response("Hello World", conn)
  end

  forward(
    @path_signup,
    to: SigninappEx.Infrastructure.EntryPoints.RestController.Signup.Application.SignupHandler
  )

  forward(
    @path_signin,
    to: SigninappEx.Infrastructure.EntryPoints.RestController.Signin.Application.SigninHandler
  )

  def build_response(%{status: status, body: body}, conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Poison.encode!(body))
  end

  def build_response(response, conn), do: build_response(%{status: 200, body: response}, conn)

  match _ do
    conn
    |> handle_not_found(Logger.level())
  end

  # defp build_bad_request_error_response(response, conn) do
  #   build_response(%{status: 400, body: response}, conn)
  # end

  defp handle_not_found(conn, :debug) do
    %{request_path: path} = conn
    body = Poison.encode!(%{status: 404, path: path})
    send_resp(conn, 404, body)
  end

  defp handle_not_found(conn, _level) do
    send_resp(conn, 404, "")
  end
end
