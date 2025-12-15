defmodule SigninappEx.Infrastructure.EntryPoints.Shared.ResponseSuccessBody do
  @moduledoc """
  Module to transform and validate the input for ResponseSuccessBody
  """

  def build_response(response_body, message_id) do
    %{
      "meta" => %{
        "_messageId" => message_id,
        "_requestDateTime" => get_request_date()
      },
      "data" => response_body
    }
  end

  defp get_request_date() do
    now =
      DateTime.utc_now()
      |> Timex.to_datetime("America/Bogota")
      |> Timex.format!("{ISO:Extended}")

    String.replace(now, ~r/(\.\d{3})\d+/, "\\1")
  end
end
