defmodule SigninappEx.Infrastructure.EntryPoints.RestController.Signup.Infra.SignupBuild do
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.Command
  alias SigninappEx.Domain.Model.Signup.Model.SignupDto
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.ContextData

  def build_command_with_dto(body_data, headers) do
    with {:ok, context} <-
           ContextData.new(
             Map.get(headers, :MESSAGE_ID, UUID.uuid4()),
             Map.get(headers, :X_REQUEST_ID)
           ) do
      case SignupDto.new(body_data.email, body_data.password, body_data.name) do
        {:ok, signup_dto} -> {:ok, %Command{payload: signup_dto, context: context}}
        {:error, reason} -> {:error, %Command{payload: reason, context: context}}
      end
    end
  end
end
