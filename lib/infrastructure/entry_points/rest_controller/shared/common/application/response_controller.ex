defmodule SigninappEx.Infrastructure.EntryPoints.RestController.Shared.Common.Application.ResponseController do
  @moduledoc """
  Provides functions to build HTTP responses.
  """
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.ContextData
  require Logger
  import Plug.Conn

  @content_security_policy [
    {"cache-control", "no-cache, no-store, must-revalidate"},
    {"x-content-type-options", "nosniff"},
    {"pragma", "no-cache"},
    {"expires", "0"},
    {"content-security-policy",
     Enum.join(
       [
         "default-src 'self'",
         "object-src 'none'",
         "script-src 'self' 'unsafe-eval'",
         "script-src-elem 'self'",
         "frame-ancestors 'none'"
       ],
       "; "
     )}
  ]

  @message_id "message-id"
  @x_request_id "x-request-id"

  @spec build_response(any(), ContextData.t(), Plug.Conn.t()) :: Plug.Conn.t()
  def build_response(%{status: status, body: body}, ctx, conn) do
    Logger.info("Building response with status #{status} and body #{inspect(body)}")

    conn
    |> put_resp_content_type("application/json")
    |> merge_resp_headers(@content_security_policy)
    |> merge_resp_headers([
      {@message_id, ctx.message_id.value},
      {@x_request_id, ctx.x_request_id.value}
    ])
    |> send_resp(status, Poison.encode!(body))
  end
  def build_response(response, ctx, conn) when map_size(response) == 0 do
    conn
    |> put_resp_content_type("application/json")
    |> merge_resp_headers(@content_security_policy)
    |> merge_resp_headers([
      {@message_id, ctx.message_id.value},
      {@x_request_id, ctx.x_request_id.value}
    ])
    |> handle_not_results()
  end

  @spec build_ok_response(any(), ContextData.t(), Plug.Conn.t()) :: Plug.Conn.t()
  def build_ok_response(response, ctx, conn) do
    build_response(%{status: 200, body: response}, ctx, conn)
  end

  @spec build_error_response(any(), ContextData.t(), Plug.Conn.t()) :: Plug.Conn.t()
  def build_error_response(
        %{status: status, body: body},
        ctx,
        conn
      ) do
    Logger.info("Building error response with status #{status} and body #{inspect(body)}")

    response = %{
              error: %{
                code: body.code,
                message: body.message,
                details: body.details,
                correlation: %{
                  message_id: ctx.message_id.value,
                  x_request_id: ctx.x_request_id.value
                }
              }
            }

    conn
    |> put_resp_content_type("application/json")
    |> merge_resp_headers(@content_security_policy)
    |> merge_resp_headers([
      {@message_id, ctx.message_id.value},
      {@x_request_id, ctx.x_request_id.value}
    ])
    |> send_resp(status, Poison.encode!(response))
  end

  defp handle_not_results(conn) do
    send_resp(conn, 201, "")
  end
end
