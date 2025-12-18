defmodule SigninappEx.Infrastructure.EntryPoints.RestController.Shared.Common.Application.ResponseController do
  @moduledoc """
  Provides functions to build HTTP responses.
  """
  alias SigninappEx.Infrastructure.EntryPoints.RestController.Shared.Common.Application.DataTypeUtils
  alias SigninappEx.Infrastructure.EntryPoints.RestController.Shared.Common.Infra.PrintEcsLog

  alias SigninappEx.Infrastructure.EntryPoints.RestController.Shared.Common.Domain.EcsModelResponse

  alias SigninappEx.Domain.Model.Shared.Exception.Exceptions
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
    message_id = Map.get(Map.get(ctx, :message_id), :value)
    x_request_id = Map.get(Map.get(ctx, :x_request_id), :value)

    conn
    |> put_resp_content_type("application/json")
    |> merge_resp_headers(@content_security_policy)
    |> merge_resp_headers([
      {@message_id, message_id},
      {@x_request_id, x_request_id}
    ])
    |> send_resp(status, Poison.encode!(body))
  end

  def build_response(response, ctx, conn) when map_size(response) == 0 do
    message_id = Map.get(Map.get(ctx, :message_id), :value)
    x_request_id = Map.get(Map.get(ctx, :x_request_id), :value)

    conn
    |> put_resp_content_type("application/json")
    |> merge_resp_headers(@content_security_policy)
    |> merge_resp_headers([
      {@message_id, message_id},
      {@x_request_id, x_request_id}
    ])
    |> handle_not_results()
  end

  @spec build_ok_response(any(), ContextData.t(), Plug.Conn.t()) :: Plug.Conn.t()
  def build_ok_response(response, ctx, conn) do
    build_response(%{status: 200, body: response}, ctx, conn)
  end

  @spec build_error_response(Exceptions.t(), ContextData.t(), Plug.Conn.t()) :: Plug.Conn.t()
  def build_error_response(%Exceptions{} = exception, ctx, conn) do
    message_id = Map.get(Map.get(ctx, :message_id), :value)
    x_request_id = Map.get(Map.get(ctx, :x_request_id), :value)

    EcsModelResponse.build_structure(exception, message_id, conn)
    |> PrintEcsLog.print_ecs_log()

    response = %{
      error: %{
        code: Map.get(exception, :code),
        message: Map.get(exception, :detail),
        details: Map.get(exception, :category),
        correlation: %{
          message_id: message_id,
          x_request_id: x_request_id
        }
      }
    }

    conn
    |> put_resp_content_type("application/json")
    |> merge_resp_headers(@content_security_policy)
    |> merge_resp_headers([
      {@message_id, message_id},
      {@x_request_id, x_request_id}
    ])
    |> send_resp(Map.get(exception, :status, 500), Poison.encode!(response))
  end

  defp handle_not_results(conn) do
    send_resp(conn, 201, "")
  end
end
