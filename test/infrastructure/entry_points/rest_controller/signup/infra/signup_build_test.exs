defmodule SigninappEx.Infrastructure.EntryPoints.RestController.Signup.Infra.SignupBuildTest do
  use ExUnit.Case, async: true

  alias SigninappEx.Infrastructure.EntryPoints.RestController.Signup.Infra.SignupBuild
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.Command
  alias SigninappEx.Domain.Model.Signup.Model.SignupDto
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.ContextData

  @valid_msg "550e8400-e29b-41d4-a716-446655440000"
  @valid_xreq "550e8400-e29b-41d4-a716-446655440001"

  describe "build_command_with_dto/2" do
    test "happy path: builds command with dto when body and headers valid" do
      body = %{email: "user@example.com", password: "StrongP@ssw0rd", name: "Name"}
      headers = %{MESSAGE_ID: @valid_msg, X_REQUEST_ID: @valid_xreq}

      assert {:ok, %Command{payload: %SignupDto{} = dto, context: %ContextData{} = ctx}} =
               SignupBuild.build_command_with_dto(body, headers)

      assert dto.email.value == "user@example.com"
      assert dto.password.value == "StrongP@ssw0rd"
      assert dto.name.value == "Name"
      assert ctx.message_id.value == @valid_msg
      assert ctx.x_request_id.value == @valid_xreq
    end

    test "when MESSAGE_ID missing generates one and x_request_id defaults to it" do
      body = %{email: "user@example.com", password: "StrongP@ssw0rd"}
      headers = %{}

      assert {:ok, %Command{payload: %SignupDto{}, context: %ContextData{} = ctx}} =
               SignupBuild.build_command_with_dto(body, headers)

      # x_request_id should equal message_id when not provided
      assert ctx.x_request_id.value == ctx.message_id.value
      assert is_binary(ctx.message_id.value)
      assert String.length(ctx.message_id.value) > 0
    end

    test "returns error when message id is invalid" do
      body = %{email: "user@example.com", password: "StrongP@ssw0rd"}
      headers = %{MESSAGE_ID: "not-a-uuid"}

      assert {:error, :message_id_invalid_format} = SignupBuild.build_command_with_dto(body, headers)
    end

    test "returns error when x_request_id is invalid" do
      body = %{email: "user@example.com", password: "StrongP@ssw0rd"}
      headers = %{MESSAGE_ID: @valid_msg, X_REQUEST_ID: "invalid"}

      assert {:error, :x_request_id_invalid_format} = SignupBuild.build_command_with_dto(body, headers)
    end

    test "returns error when email is invalid format" do
      body = %{email: "userexample.com", password: "StrongP@ssw0rd"}
      headers = %{MESSAGE_ID: @valid_msg}

      assert {:error, %Command{payload: :email_invalid_format, context: %ContextData{}}} =
               SignupBuild.build_command_with_dto(body, headers)
    end

    test "returns error when email is missing" do
      body = %{password: "StrongP@ssw0rd"}
      headers = %{MESSAGE_ID: @valid_msg}

      assert {:error, %Command{payload: :email_empty, context: %ContextData{}}} =
               SignupBuild.build_command_with_dto(body, headers)
    end

    test "returns error when password is missing" do
      body = %{email: "user@example.com"}
      headers = %{MESSAGE_ID: @valid_msg}

      assert {:error, %Command{payload: :password_empty, context: %ContextData{}}} =
               SignupBuild.build_command_with_dto(body, headers)
    end

    test "accepts missing name and sets name to nil" do
      body = %{email: "user@example.com", password: "StrongP@ssw0rd"}
      headers = %{MESSAGE_ID: @valid_msg}

      assert {:ok, %Command{payload: %SignupDto{name: %{} = name_struct}}} =
               SignupBuild.build_command_with_dto(body, headers)

      # Name.new returns {:ok, %Name{value: nil}} when name missing
      assert Map.has_key?(name_struct, :value)
      assert name_struct.value == nil
    end

    test "returns error when email has invalid type (charlist)" do
      body = %{email: ["u", "s", "e", "r", "@", "e", "x", "a", "m", "p", "l", "e"], password: "StrongP@ssw0rd"}
      headers = %{MESSAGE_ID: @valid_msg}

      assert {:error, %Command{payload: :email_invalid_type, context: %ContextData{}}} =
               SignupBuild.build_command_with_dto(body, headers)
    end
  end
end
