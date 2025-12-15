defmodule SigninappEx.Domain.UseCases.Signup.SignupUseCaseTest do
  use ExUnit.Case, async: true
  import Mock
  import ExUnit.CaptureLog

  alias SigninappEx.Domain.UseCases.Signup.SignupUseCase
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.Command
  alias SigninappEx.Domain.Model.Signup.Model.SignupDto
  alias SigninappEx.Domain.Model.Shared.Cqrs.ContextData

  @gateway SigninappEx.DrivenAdapters.Localstorage.Signup.Application.SignupWriteGateway

  describe "execute_sign_up/1" do
    test "delegates to sign_up gateway and returns its result" do
      {:ok, dto} = SignupDto.new("user@example.com", "StrongP@ssw0rd", "Name")
      # Use valid v4 UUIDs (MessageId expects a v4 UUID format)
      {:ok, context} = ContextData.new("550e8400-e29b-41d4-a716-446655440000", "550e8400-e29b-41d4-a716-446655440001")

      command = %Command{payload: dto, context: context}

      with_mock @gateway, [sign_up: fn received_command ->
        # ensure the gateway receives exactly the same command
        assert received_command == command
        {:ok, :created}
      end] do
        log = capture_log(fn ->
          assert {:ok, :created} == SignupUseCase.execute_sign_up(command)
        end)

        assert log =~ "Usecase command:"
      end
    end

    test "raises FunctionClauseError when argument does not match required pattern" do
      assert_raise FunctionClauseError, fn ->
        SignupUseCase.execute_sign_up(%Command{payload: %{}, context: %{}})
      end
    end
  end
end
