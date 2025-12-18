defmodule SigninappEx.Infrastructure.EntryPoints.RestController.Signup.Application.SignupHandler do
  use Plug.Router
  require Logger

  alias SigninappEx.Infrastructure.EntryPoints.RestController.Shared.Common.Application.ResponseSuccessController
  alias SigninappEx.Infrastructure.EntryPoints.RestController.Shared.Common.Application.ResponseErrorController
  alias SigninappEx.Infrastructure.EntryPoints.RestController.Shared.Common.Application.DataTypeUtils
  alias SigninappEx.Infrastructure.EntryPoints.RestController.Signup.Infra.SignupBuild
  alias SigninappEx.Domain.Model.Shared.Exception.Exceptions
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.Command
  alias SigninappEx.Domain.UseCases.Signup.SignupUseCase

  plug(:match)
  plug(:dispatch)

  @path "/"

  post @path do
    Logger.debug("Ejecutando SignUP handler")

    headers = conn.req_headers |> DataTypeUtils.normalize_headers()
    body = conn.body_params |> DataTypeUtils.normalize()

    with {:ok, %Command{} = init_command} <- SignupBuild.build_command_with_dto(body, headers),
         {:ok, %Command{} = use_case_command} <- SignupUseCase.execute_sign_up(init_command) do
      # Return 201 with no body
      ResponseSuccessController.build_response(%{}, use_case_command.context, conn)
    else
      {:error, %Command{} = command_with_error} ->
        ResponseErrorController.build_error_response(
          Exceptions.build_exception(command_with_error.payload),
          command_with_error.context,
          conn
        )
    end
  end
end
