defmodule SigninappEx.Infrastructure.DrivenAdapters.Localstorage.Signup.Application.SignupWriteGateway do
  require Logger

  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.Command
  alias SigninappEx.Domain.Model.Signup.Model.SignupDto
  alias SigninappEx.Domain.Model.Shared.Common.Validate.Email
  alias SigninappEx.Domain.Model.Shared.Common.Validate.Password
  alias SigninappEx.Domain.Model.Shared.Common.Validate.Name
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.ContextData
  alias SigninappEx.Infrastructure.DrivenAdapters.Localstorage.Shared.Domain.UserEntity
  alias SigninappEx.Infrastructure.DrivenAdapters.Localstorage.Shared.Infra.UserStore

  @spec sign_up(%Command{
          :context => ContextData.t(),
          :payload => SignupDto.t()
        }) :: {:ok, :created} | {:error, :user_already_exists}
  def sign_up(%Command{
        payload: %SignupDto{
          email: %Email{value: email},
          password: %Password{value: password},
          name: %Name{value: name}
        },
        context: %ContextData{}
      }) do
    user_entity = %UserEntity{email: email, password: password, name: name}

    # Persist user in in-memory store. If duplicate, return error.
    case UserStore.put(user_entity) do
      {:ok, _user} ->
        Logger.info("Saved user: #{inspect(%{user_entity | password: "****"})}")
        {:ok, :created}

      {:error, :already_exists} ->
        {:error, :user_already_exists}
    end
  end
end
