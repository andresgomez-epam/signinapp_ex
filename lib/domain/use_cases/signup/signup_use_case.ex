defmodule SigninappEx.Domain.UseCases.Signup.SignupUseCase do
  @moduledoc """
  Use case for user sign-up functionality.
  """
  alias Domain.UseCases.Signup.Validatepassword.SignUpValidatePassUseCase
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.Command
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.Query
  alias SigninappEx.Domain.Model.Signup.Model.SignupDto
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.ContextData

  @sign_up_write_gateway Application.compile_env!(:signinapp_ex, :sign_up_write_gateway)

  @spec execute_sign_up(%Command{
          :context => ContextData.t(),
          :payload => SignupDto.t()
        }) :: {:ok, %Query{}} | {:error, %Query{}}
  def execute_sign_up(
        %Command{
          payload: %SignupDto{} = signup_dto,
          context: %ContextData{} = ctx
        } = command
      ) do
    with {:ok, :password_valid} <- validate_pass(signup_dto, ctx),
         {:ok, :created} <- @sign_up_write_gateway.sign_up(command) do
      {:ok, %Command{command | payload: :created}}
    else
      {:error, reason} ->
        {:error, %Command{command | payload: reason}}
    end
  end

  @spec validate_pass(SignupDto.t(), ContextData.t()) ::
          {:ok, :password_valid} | {:error, :password_weak}
  defp validate_pass(signup_dto, ctx) do
    query = %Query{
      payload: signup_dto.password.value,
      context: ctx
    }

    SignUpValidatePassUseCase.validate_password(query)
  end
end
