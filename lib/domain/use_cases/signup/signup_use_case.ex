defmodule SigninappEx.Domain.UseCases.Signup.SignupUseCase do
  @moduledoc """
  Use case for user sign-up functionality.
  """

  require Logger

  alias Domain.UseCases.Signup.Validatepassword.SignUpValidatePassUseCase
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.Command
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.Query
  alias SigninappEx.Domain.Model.Signup.Model.SignupDto
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.ContextData

  @sign_up_write_gateway Application.compile_env!(:signinapp_ex, :sign_up_write_gateway)

  @spec execute_sign_up(%Command{
          :context => ContextData.t(),
          :payload => SignupDto.t()
        }) :: {:error, any()} | {:ok, :created}
  def execute_sign_up(
        %Command{
          payload: %SignupDto{},
          context: %ContextData{}
        } = command
      ) do
    Logger.info("Usecase command: #{inspect(command)}")

    query = %Query{
      payload: command.payload.password.value,
      context: command.context
    }
    with {:ok, :password_valid} <- SignUpValidatePassUseCase.validate_password(query),
         {:ok, :created} <- @sign_up_write_gateway.sign_up(command) do
      {:ok, %Command{command | payload: :created}}
    else
      {:error, reason} ->
        Logger.error("Signup use case error: #{inspect(reason)}")
        {:error, %Command{command | payload: reason}}
    end
  end
end
