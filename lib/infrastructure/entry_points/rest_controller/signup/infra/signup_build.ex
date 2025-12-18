defmodule SigninappEx.Infrastructure.EntryPoints.RestController.Signup.Infra.SignupBuild do
  require Logger

  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.Command
  alias SigninappEx.Domain.Model.Signup.Model.SignupDto
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.ContextData

  @spec build_command_with_dto(any(), map()) ::
          {:ok, %Command{context: ContextData.t(), payload: SignupDto.t()}}
          | {:error,
             :message_id_empty
             | :message_id_invalid_format
             | :message_id_invalid_type
             | :x_request_id_empty
             | :x_request_id_invalid_format
             | :x_request_id_invalid_type
             | %Command{
                 context: ContextData.t(),
                 payload:
                   :email_empty
                   | :email_invalid_format
                   | :email_invalid_type
                   | :name_invalid_type
                   | :password_empty
                   | :password_invalid_type
               }}
  def build_command_with_dto(body_data, headers) do
    Logger.debug("Ejecutando SignUPBuild build_command_with_dto")

    with {:ok, context} <-
           ContextData.new(
             Map.get(headers, :MESSAGE_ID, UUID.uuid4()),
             Map.get(headers, :X_REQUEST_ID)
           ) do
      case SignupDto.new(
             Map.get(body_data, :email, nil),
             Map.get(body_data, :password, nil),
             Map.get(body_data, :name, nil)
           ) do
        {:ok, signup_dto} -> {:ok, %Command{payload: signup_dto, context: context}}
        {:error, reason} -> {:error, %Command{payload: reason, context: context}}
      end
    end
  end
end
