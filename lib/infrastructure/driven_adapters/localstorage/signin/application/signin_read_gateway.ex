defmodule SigninappEx.Infrastructure.DrivenAdapters.Localstorage.Signin.Application.SigninReadGateway do
  require Logger

  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.Query
  alias SigninappEx.Infrastructure.DrivenAdapters.Localstorage.Shared.Infra.UserStore
  alias SigninappEx.Domain.Model.Shared.Common.Model.UserDto

  def search_user(%Query{} = query) do
    # Implementation for searching user in local storage
    case UserStore.get(query.payload.email.value) do
      nil ->
        Logger.warning("User not found: #{inspect(query.payload.email.value)}")
        {:error, :user_not_found}

      user_entity ->
        Logger.info("User found #{inspect(user_entity)}")
        user = toUserDto(user_entity)
        Logger.info("Mapped user entity to DTO: #{inspect(user)}")
        user
    end
  end

  defp toUserDto(user_entity) do
    UserDto.new(user_entity.email, user_entity.password, user_entity.name)
  end
end
