defmodule SigninappEx.Infrastructure.EntryPoints.RestController.Signin.Application.SigninHandler do
  use Plug.Router
  require Logger

  alias SigninappEx.Infrastructure.EntryPoints.RestController.Shared.Common.Application.ResponseSuccessController
  alias SigninappEx.Infrastructure.EntryPoints.RestController.Shared.Common.Application.ResponseErrorController
  alias SigninappEx.Infrastructure.EntryPoints.RestController.Shared.Common.Application.DataTypeUtils
  alias SigninappEx.Infrastructure.EntryPoints.RestController.Signin.Infra.SigninBuild
  alias SigninappEx.Domain.Model.Shared.Exception.Exceptions
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.Query
  alias SigninappEx.Domain.UseCases.Signin.SigninUseCase

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
      ResponseSuccessController.build_ok_response(response, use_case_query.context, conn)
    else
      {:error, %Query{} = query_with_error} ->
        ResponseErrorController.build_error_response(
          Exceptions.build_exception(query_with_error.payload),
          query_with_error.context,
          conn
        )
    end
  end
end
