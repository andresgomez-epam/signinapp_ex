defmodule Infrastructure.EntryPoints.RestController.Shared.Common.Domain.ResponseErrorBody do
  @moduledoc """
  Module to build an error response body
  """

  def build_response(error_body, message_id) do
    %{
      error: %{
        "code" => error_body.code,
        "message" => error_body.message,
        "details" => error_body.details,
        "correlation" => %{
          "message_id" => message_id,
          "x_request_id" => error_body.x_request_id
        }
      }
    }
  end
end
