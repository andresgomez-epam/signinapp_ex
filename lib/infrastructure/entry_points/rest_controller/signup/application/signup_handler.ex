defmodule SigninappEx.EntryPoints.RestController.Signup.Application.SignupHandler do
  alias SigninappEx.Shared.ResponseController
  alias SigninappEx.Infrastructure.EntryPoint.Shared.ResponseSuccessBody
  alias SigninappEx.EntryPoints.RestController.Shared.Common.Application.DataTypeUtils
  alias SigninappEx.EntryPoints.RestController.Signup.Infra.SignupBuild
  alias SigninappEx.Domain.UseCases.Signup.SignupUseCase

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

    with {:ok, command} <- SignupBuild.build_command_with_dto(body, headers),
         {:ok, _} <- SignupUseCase.execute_sign_up(command) do
      message_id = Map.get(headers, :MESSAGE_ID, "")

      ResponseSuccessBody.build_response(nil, message_id)
      |> ResponseController.build_response(conn)
    end
  end
end
