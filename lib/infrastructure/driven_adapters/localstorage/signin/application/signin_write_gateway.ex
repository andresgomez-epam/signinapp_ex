defmodule SigninappEx.Infrastructure.DrivenAdapters.Localstorage.Signin.Application.SigninWriteGateway do
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.Query
  alias SigninappEx.Infrastructure.DrivenAdapters.Localstorage.Shared.Infra.UserStore

  def sign_in(%Query{} = query) do
    # Implementation for signing in user in local storage
    {:ok, %Query{query | payload: UUID.uuid4()}}
  end
end
