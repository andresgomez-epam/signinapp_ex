defmodule SigninappEx.Infrastructure.EntryPoints.RestController.Shared.Common.Domain.EcsModelResponse do
  @moduledoc """
  This module is responsible for building responses.
  """
  alias SigninappEx.Domain.Model.Shared.Exception.Exceptions

  alias SigninappEx.Infrastructure.EntryPoints.RestController.Shared.Common.Application.DataTypeUtils

  @service_name "signinapp_ex"
  @level_error "ERROR"
  @level_info "INFO"

  @derive Jason.Encoder
  defstruct [
    :messageId,
    :date,
    :service,
    :level,
    :additionalInfo,
    :error
  ]

  def build_structure(%Exceptions{} = data, message_id, conn) do
    now = DateTime.utc_now() |> Timex.to_datetime("America/Bogota")

    %__MODULE__{
      messageId: message_id,
      date: format_datetime(now),
      service: @service_name,
      level: @level_error,
      error: build_error(data),
      additionalInfo: build_additional_info(conn)
    }
  end

  def build_structure(data, message_id, conn) do
    now = DateTime.utc_now() |> Timex.to_datetime("America/Bogota")

    %__MODULE__{
      messageId: message_id,
      date: format_datetime(now),
      service: @service_name,
      level: @level_info,
      error: nil,
      additionalInfo: build_additional_info(data, conn)
    }
  end

  def build_error(data) do
    %{
      status: Map.get(data, :status),
      message: Map.get(data, :detail),
      errorCode: Map.get(data, :code),
      internalMessage: Map.get(data, :log_message),
      logCode: Map.get(data, :log_code),
      type: @level_error,
      optional_info:
        if(is_nil(Map.get(data, :additional_info)),
          do: "",
          else: Map.get(data, :additional_info)
        )
    }
  end

  def build_additional_info(conn) do
    %{
      method: Map.get(conn, :method),
      uri: Map.get(conn, :request_path),
      requestBody: Map.get(conn, :body_params, %{})
    }
  end

  def build_additional_info(data, conn) do
    headers = conn.resp_headers |> DataTypeUtils.normalize_headers()

    %{
      method: Map.get(conn, :method),
      uri: Map.get(conn, :request_path),
      requestBody: Map.get(conn, :body_params, %{}),
      responseBody: Map.get(data, :body),
      responseCode: elem(Map.get(data, :status), 0),
      responseResult: elem(Map.get(data, :status), 1),
      headers: headers
    }
  end

  defp format_datetime(datetime) do
    "#{datetime.year}/#{datetime.month}/#{datetime.day} #{pad_zero(datetime.hour)}:#{pad_zero(datetime.minute)}:#{pad_zero(datetime.second)}:#{elem(datetime.microsecond, 0)}"
  end

  defp pad_zero(value) when value < 10, do: "0#{value}"
  defp pad_zero(value), do: "#{value}"
end
