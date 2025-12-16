defmodule SigninappEx.Infrastructure.EntryPoints.RestController.Signin.Infra.SigninBuild do
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.Query
  alias SigninappEx.Domain.Model.Signin.Model.SigninDto
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.ContextData

  def build_query_with_dto(body_data, headers) do
    with {:ok, context} <-
           ContextData.new(
             Map.get(headers, :MESSAGE_ID, UUID.uuid4()),
             Map.get(headers, :X_REQUEST_ID)
           ) do
      case SigninDto.new(Map.get(body_data, :email), Map.get(body_data, :password)) do
        {:ok, signin_dto} -> {:ok, %Query{payload: signin_dto, context: context}}
        {:error, reason} -> {:error, %Query{payload: reason, context: context}}
      end
    end
  end
end
