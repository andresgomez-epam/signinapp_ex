defmodule SigninappEx.DrivenAdapters.Localstorage.Signup.Application.SignupWriteGateway do
  require Logger

  # Import repo
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.Command
  alias SigninappEx.Domain.Model.Signup.Model.SignupDto
  alias SigninappEx.Domain.Model.Shared.Common.Validate.Email
  alias SigninappEx.Domain.Model.Shared.Common.Validate.Password
  alias SigninappEx.Domain.Model.Shared.Common.Validate.Name
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.ContextData
  alias SigninappEx.Infrastructure.DrivenAdapters.Localstorage.Shared.Domain.UserEntity
  alias SigninappEx.Infrastructure.DrivenAdapters.Localstorage.Shared.Infra.UserStore

  def sign_up(
        %Command{
          payload: %SignupDto{
            email: %Email{value: email},
            password: %Password{value: password},
            name: %Name{value: name}
          },
          context: %ContextData{message_id: message_id}
        } = command
      ) do
    Logger.info("Gateway command: #{inspect(command)}")

    user_entity = %UserEntity{email: email, password: password, name: name}
    # Persist user in in-memory store. If duplicate, log and continue (simulate DB unique constraint behavior).
    case UserStore.put(user_entity) do
      {:ok, _user} ->
        :ok
        Logger.info("Saved user: #{inspect(user_entity)}")
      {:error, :already_exists} -> Logger.warning("User already exists: #{email}")
      {:error, reason} -> Logger.error("UserStore.put error: #{inspect(reason)}")
      other -> Logger.debug("UserStore.put returned unexpected: #{inspect(other)}")
    end

    {:ok, nil}
  end
end
