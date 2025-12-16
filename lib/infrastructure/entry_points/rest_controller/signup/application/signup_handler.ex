defmodule SigninappEx.Infrastructure.EntryPoints.RestController.Signup.Application.SignupHandler do
  alias SigninappEx.Infrastructure.EntryPoints.RestController.Shared.Common.Application.ResponseController

  alias SigninappEx.Infrastructure.EntryPoints.RestController.Shared.Common.Application.DataTypeUtils

  alias SigninappEx.Infrastructure.EntryPoints.RestController.Signup.Infra.SignupBuild
  alias SigninappEx.Domain.UseCases.Signup.SignupUseCase
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.Command

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

    with {:ok, %Command{} = init_command} <- SignupBuild.build_command_with_dto(body, headers),
         {:ok, %Command{} = use_case_command} <- SignupUseCase.execute_sign_up(init_command) do
      # Return 201 with no body
      ResponseController.build_response(%{}, use_case_command.context, conn)
    else
      {:error, %Command{} = command_with_error} ->
        Logger.error("SignUP_Handler error: #{inspect(command_with_error.payload)}")

        ResponseController.build_error_response(
          %{
            status: 400,
            body: %{
              code: "SIGNUP_ERROR",
              message: "User sign-up failed.",
              details: command_with_error.payload
            }
          },
          command_with_error.context,
          conn
        )
    end
  end
end
