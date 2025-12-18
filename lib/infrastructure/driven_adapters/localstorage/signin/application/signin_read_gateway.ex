defmodule SigninappEx.Infrastructure.DrivenAdapters.Localstorage.Signin.Application.SigninReadGateway do
  @moduledoc """
  Local storage implementation of the Signin read gateway.
  """

  require Logger

  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.Query
  alias SigninappEx.Infrastructure.DrivenAdapters.Localstorage.Shared.Infra.UserStore
  alias SigninappEx.Domain.Model.Shared.Common.Model.UserDto

  @spec search_user(%Query{}) :: {:ok, UserDto.t()} | {:error, :user_not_found}
  def search_user(%Query{} = query) do
    case UserStore.get(query.payload.email.value) do
      nil ->
        {:error, :user_not_found}

      user_entity ->
        toUserDto(user_entity)
    end
  end

  defp toUserDto(user_entity) do
    UserDto.new(user_entity.email, user_entity.password, user_entity.name)
  end
end
