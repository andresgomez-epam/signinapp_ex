defmodule SigninappEx.Infrastructure.EntryPoints.RestController.Signin.Application.SigninHandler do
  alias SigninappEx.Domain.Model.Shared.Exception.Exceptions

  alias SigninappEx.Infrastructure.EntryPoints.RestController.Shared.Common.Application.ResponseController

  alias SigninappEx.Infrastructure.EntryPoints.RestController.Shared.Common.Application.DataTypeUtils

  alias SigninappEx.Infrastructure.EntryPoints.RestController.Signin.Infra.SigninBuild
  alias SigninappEx.Domain.UseCases.Signin.SigninUseCase
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.Query

  use Plug.Router
  require Logger

  plug(:match)
  plug(:dispatch)

  @path "/"

  post @path do
    Logger.debug("Ejecutando SignIN handler")
    headers = conn.req_headers |> DataTypeUtils.normalize_headers()
    body = conn.body_params |> DataTypeUtils.normalize()

    with {:ok, %Query{} = init_query} <- SigninBuild.build_query_with_dto(body, headers),
         {:ok, %Query{} = use_case_query} <- SigninUseCase.execute_signin(init_query) do
      # Return 200 with no body
      response = %{session_id: use_case_query.payload}
      ResponseController.build_ok_response(response, use_case_query.context, conn)
    else
      {:error, %Query{} = query_with_error} ->
        ResponseController.build_error_response(
          Exceptions.build_exception(query_with_error.payload),
          query_with_error.context,
          conn
        )
    end
  end
end
