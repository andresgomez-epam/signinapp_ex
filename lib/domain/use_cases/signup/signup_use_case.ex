defmodule SigninappEx.Domain.UseCases.Signup.SignupUseCase do
  @moduledoc """
  Use case for user sign-up functionality.
  """

  require Logger

  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.Command
  alias SigninappEx.Domain.Model.Signup.Model.SignupDto
  alias SigninappEx.Domain.Model.Shared.Cqrs.ContextData

  @sign_up_write_gateway Application.compile_env!(:signinapp_ex, :sign_up_write_gateway)

  def execute_sign_up(
        %Command{
          payload: %SignupDto{},
          context: %ContextData{}
        } = command
      ) do
    Logger.info("Usecase command: #{inspect(command)}")
    @sign_up_write_gateway.sign_up(command)
  end
end
