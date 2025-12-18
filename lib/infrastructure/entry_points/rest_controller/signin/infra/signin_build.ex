defmodule SigninappEx.Infrastructure.EntryPoints.RestController.Signin.Infra.SigninBuild do
  @moduledoc """
  Build Query objects for Sign-In use case from HTTP request data.
  """
  require Logger
  
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.Query
  alias SigninappEx.Domain.Model.Signin.Model.SigninDto
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.ContextData

  @spec build_query_with_dto(any(), map()) ::
          {:ok, %Query{context: ContextData.t(), payload: SigninDto.t()}}
          | {:error,
             :message_id_empty
             | :message_id_invalid_format
             | :message_id_invalid_type
             | :x_request_id_empty
             | :x_request_id_invalid_format
             | :x_request_id_invalid_type
             | %Query{
                 context: ContextData.t(),
                 payload:
                   :email_empty
                   | :email_invalid_format
                   | :email_invalid_type
                   | :password_empty
                   | :password_invalid_type
               }}
  def build_query_with_dto(body_data, headers) do
    Logger.debug("Ejecutando SignINBuild build_query_with_dto")

    with {:ok, context} <-
           ContextData.new(
             Map.get(headers, :MESSAGE_ID, UUID.uuid4()),
             Map.get(headers, :X_REQUEST_ID)
           ) do
      case SigninDto.new(Map.get(body_data, :email), Map.get(body_data, :password)) do
        {:ok, signin_dto} -> {:ok, %Query{payload: signin_dto, context: context}}
        {:error, reason} -> {:error, %Query{payload: reason, context: context}}
      end
    end
  end
end
