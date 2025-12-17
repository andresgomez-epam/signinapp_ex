defmodule SigninappEx.Infrastructure.DrivenAdapters.Localstorage.Signin.Application.SigninWriteGateway do
  @moduledoc """
  Local storage implementation of the Signin write gateway.
  """
  require UUID

  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.Query

  @spec sign_in(%Query{}) :: {:ok, %Query{}}
  def sign_in(%Query{} = query) do
    {:ok, %Query{query | payload: UUID.uuid4()}}
  end
end
