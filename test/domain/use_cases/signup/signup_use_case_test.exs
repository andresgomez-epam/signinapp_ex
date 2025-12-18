defmodule SigninappEx.Domain.UseCases.Signup.SignupUseCaseTest do
  use ExUnit.Case, async: true
  import Mock

  alias SigninappEx.Domain.UseCases.Signup.SignupUseCase
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.Command
  alias SigninappEx.Domain.Model.Signup.Model.SignupDto
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.ContextData

  @gateway SigninappEx.Infrastructure.DrivenAdapters.Localstorage.Signup.Application.SignupWriteGateway

  describe "execute_sign_up/1" do
    test "happy path: valid signup" do
      {:ok, signup_dto} = SignupDto.new("user@example.com", "StrongP@ssw0rd", "Name")

      {:ok, context} =
        ContextData.new(
          "550e8400-e29b-41d4-a716-446655440000",
          "550e8400-e29b-41d4-a716-446655440001"
        )

      command = %Command{payload: signup_dto, context: context}

      with_mock @gateway,
        sign_up: fn received_command ->
          # ensure the gateway receives exactly the same command
          assert received_command == command
          {:ok, :created}
        end do
        assert {:ok, %Command{payload: :created, context: context}} ==
                 SignupUseCase.execute_sign_up(command)
      end
    end

    test "returns error when email already exists" do
      {:ok, signup_dto} = SignupDto.new("user@example.com", "StrongP@ssw0rd", "Name")

      {:ok, context} =
        ContextData.new(
          "550e8400-e29b-41d4-a716-446655440000",
          "550e8400-e29b-41d4-a716-446655440001"
        )

      command = %Command{payload: signup_dto, context: context}

      with_mock @gateway,
        sign_up: fn received_command ->
          assert received_command == command
          {:error, :user_already_exists}
        end do
        assert {:error, %Command{payload: :user_already_exists, context: context}} ==
                 SignupUseCase.execute_sign_up(command)
      end
    end

    test "invalid email returns signup_dto construction error" do
      assert {:error, :email_invalid_format} =
               SignupDto.new("userexample.com", "StrongP@ssw0rd", "Name")
    end

    test "returns error when password is weak" do
      {:ok, signup_dto} = SignupDto.new("user@example.com", "weak", "Name")

      {:ok, context} =
        ContextData.new(
          "550e8400-e29b-41d4-a716-446655440000",
          "550e8400-e29b-41d4-a716-446655440001"
        )

      command = %Command{payload: signup_dto, context: context}

      with_mock SigninappEx.Domain.UseCases.Signup.Validatepassword.SignUpValidatePassUseCase,
        validate_password: fn _ -> {:error, :password_weak} end do
        assert {:error, %Command{payload: :password_weak, context: context}} ==
                 SignupUseCase.execute_sign_up(command)
      end
    end

    test "raises FunctionClauseError when argument does not match required pattern" do
      assert_raise FunctionClauseError, fn ->
        SignupUseCase.execute_sign_up(%Command{payload: %{}, context: %{}})
      end
    end
  end
end
