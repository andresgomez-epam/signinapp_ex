defmodule SigninappEx.Infrastructure.EntryPoints.RestController.Signup.Infra.SignupBuild do
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.Command
  alias SigninappEx.Domain.Model.Signup.Model.SignupDto
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.ContextData

  def build_command_with_dto(body_data, headers) do
    with {:ok, context} <-
           ContextData.new(Map.get(headers, :MESSAGE_ID), Map.get(headers, :X_REQUEST_ID)),
         {:ok, signup_dto} <-
           SignupDto.new(body_data.email, body_data.password, body_data.name) do
      {:ok, %Command{payload: signup_dto, context: context}}
    else
      error -> error
    end
  end
end
