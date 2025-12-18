defmodule SigninappEx.Domain.UseCases.Signin.Searchuser.SigninSearchUserUseCase do
  @moduledoc """
  Use case for searching a user during sign-in.
  """
  require Logger

  alias SigninappEx.Domain.Model.Shared.Common.Model.UserDto
  alias SigninappEx.Domain.Model.Signin.Model.SigninDto
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.ContextData
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.Query

  @signin_read_gateway Application.compile_env!(:signinapp_ex, :signin_read_gateway)

  @spec search_user(%Query{
          :payload => SigninDto.t(),
          :context => ContextData.t()
        }) ::
          {:ok, UserDto.t()}
          | {:error, :user_not_found}
  def search_user(%Query{} = query) do
    Logger.debug("Ejecutando SignINSearchUserUseCase search_user")

    @signin_read_gateway.search_user(query)
  end
end
