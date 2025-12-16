defmodule SigninappEx.Infrastructure.EntryPoints.RestController.Signup.Application.SignupHandler do
  alias SigninappEx.Infrastructure.EntryPoints.RestController.Shared.Common.Application.ResponseController
  alias SigninappEx.Infrastructure.EntryPoints.Shared.ResponseSuccessBody

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

    with {:ok, command} <- SignupBuild.build_command_with_dto(body, headers),
         {:ok, :created} <- SignupUseCase.execute_sign_up(command) do
      # Return 201 with no body
      ResponseController.build_response(%{}, conn)
    else
      {:error, %Command{} = command_with_error} ->
        Logger.error("SignupHandler use case error: #{inspect(command_with_error.payload)}")
        message_id = command_with_error.context.message_id.value
        x_request_id = command_with_error.context.x_request_id.value

        ResponseController.build_error_response(
          %{
            status: 400,
            body: %{
              error: %{
                code: "SIGNUP_FAILED",
                message: "User sign-up failed.",
                details: %{},
                correlation: %{
                  message_id: message_id,
                  x_request_id: x_request_id
                }
              }
            }
          },
          conn
        )

      {:error, reason} ->
        Logger.error("SignupHandler invariants error: #{inspect(reason)}")

        ResponseController.build_error_response(
          %{
            status: 500,
            body: %{
              error: %{
                code: "INTERNAL_SERVER_ERROR",
                message: reason |> to_string(),
                details: %{},
                correlation: nil
              }
            }
          },
          conn
        )
    end
  end
end
