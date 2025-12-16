defmodule SigninappEx.Infrastructure.EntryPoints.RestController.Shared.Common.Application.ResponseController do
  @moduledoc """
  Provides functions to build HTTP responses.
  """
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

  @spec build_response(any(), Plug.Conn.t()) :: Plug.Conn.t()
  def build_response(%{status: status, body: body} = input, conn) do
    Logger.debug("Input to build_response: #{inspect(input)}")
    Logger.info("Building response with status #{status} and body #{inspect(body)}")

    conn
    |> put_resp_content_type("application/json")
    |> merge_resp_headers(@content_security_policy)
    |> merge_resp_headers(add_traces_headers(conn))
    |> send_resp(status, Poison.encode!(body))
  end

  def build_response(response, conn) when map_size(response) == 0 do
    handle_not_results(conn)
  end

  def build_response(response, conn), do: build_response(%{status: 200, body: response}, conn)

  @spec build_error_response(any(), Plug.Conn.t()) :: Plug.Conn.t()
  def build_error_response(
        %{status: status, body: %{error: %{correlation: nil}} = body} = input,
        conn
      ) do
    Logger.debug("Input to build_error_response nil correlation: #{inspect(input)}")
    Logger.info("Building error response with status #{status} and body #{inspect(body)}")

    conn
    |> put_resp_content_type("application/json")
    |> merge_resp_headers(@content_security_policy)
    |> merge_resp_headers(add_traces_headers(conn))
    |> send_resp(status, Poison.encode!(body))
  end

  @spec build_error_response(any(), Plug.Conn.t()) :: Plug.Conn.t()
  def build_error_response(
        %{status: status, body: body} = input,
        conn
      ) do
    Logger.debug("Input to build_error_response: #{inspect(input)}")
    Logger.info("Building error response with status #{status} and body #{inspect(body)}")

    conn
    |> put_resp_content_type("application/json")
    |> merge_resp_headers(@content_security_policy)
    |> merge_resp_headers([
      {@message_id, body.error.correlation.message_id},
      {@x_request_id, body.error.correlation.x_request_id}
    ])
    |> send_resp(status, Poison.encode!(body))
  end

  defp add_traces_headers(%{req_headers: request_headers}) do
    init_headers =
      Enum.filter(request_headers, fn
        {key, value} ->
          (String.equivalent?(@message_id, key) or String.equivalent?(@x_request_id, key)) and
            String.trim(value) != ""
      end)
      |> Enum.into(%{})

    message_id = Map.get(init_headers, @message_id, UUID.uuid4())

    [
      {@message_id, message_id},
      {@x_request_id, message_id}
    ]
  end

  defp handle_not_results(conn) do
    send_resp(conn, 201, "")
  end
end
