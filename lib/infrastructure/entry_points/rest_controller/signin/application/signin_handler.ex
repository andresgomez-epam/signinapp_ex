defmodule SigninappEx.Infrastructure.EntryPoints.RestController.Signin.Application.SigninHandler do
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
    headers = conn.req_headers |> DataTypeUtils.normalize_headers()
    body = conn.body_params |> DataTypeUtils.normalize()

    Logger.info("Normalized headers: #{inspect(headers)}")
    Logger.info("Normalized request body: #{inspect(body)}")

    with {:ok, %Query{} = init_query} <- SigninBuild.build_query_with_dto(body, headers),
         {:ok, %Query{} = use_case_query} <- SigninUseCase.execute_signin(init_query) do
      # Return 200 with no body
      response = %{session_id: use_case_query.payload}
      ResponseController.build_ok_response(response, use_case_query.context, conn)
    else
      {:error, %Query{} = query_with_error} ->
        Logger.error("SignIN_Handler error: #{inspect(query_with_error.payload)}")

        ResponseController.build_error_response(
          %{
            status: 400,
            body: %{
              code: "SIGNIN_ERROR",
              message: "User sign-in failed.",
              details: query_with_error.payload
            }
          },
          query_with_error.context,
          conn
        )
    end
  end
end
