defmodule SigninappEx.Domain.UseCases.Signin.SigninUseCase do
  @moduledoc """
  Use case for user sign-in functionality.
  """
  require Logger

  alias SigninappEx.Domain.UseCases.Signin.Searchuser.SigninSearchUserUseCase
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.ContextData
  alias SigninappEx.Domain.Model.Signin.Model.SigninDto
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.Query

  @signin_write_gateway Application.compile_env!(:signinapp_ex, :signin_write_gateway)

  @spec execute_signin(%Query{
          :payload => SigninDto.t(),
          :context => ContextData.t()
        }) ::
          {:ok, %Query{payload: UUID.t(), context: ContextData.t()}}
          | {:error, %Query{payload: any(), context: ContextData.t()}}
  def execute_signin(%Query{} = query) do
    Logger.debug("Ejecutando SignINUseCase execute_signin")

    with {:ok, user} <- SigninSearchUserUseCase.search_user(query),
         {:ok, :password_match} <- check_password(user, query),
         {:ok, result} <- @signin_write_gateway.sign_in(query) do
      {:ok, result}
    else
      {:error, reason} ->
        {:error, %Query{query | payload: reason}}
    end
  end

  defp check_password(user, query) do
    Logger.debug("Ejecutando SignINUseCase check_password")

    if user.password.value === query.payload.password.value do
      {:ok, :password_match}
    else
      {:error, :invalid_credentials}
    end
  end
end
