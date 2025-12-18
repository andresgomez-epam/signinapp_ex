defmodule SigninappEx.Infrastructure.EntryPoints.RestController.Signin.Infra.SigninBuildTest do
  use ExUnit.Case, async: true

  alias SigninappEx.Domain.Model.Shared.Cqrs.Validate.XRequestId
  alias SigninappEx.Domain.Model.Shared.Cqrs.Validate.MessageId
  alias SigninappEx.Domain.Model.Shared.Common.Validate.Password
  alias SigninappEx.Domain.Model.Shared.Common.Validate.Email
  alias SigninappEx.Infrastructure.EntryPoints.RestController.Signin.Infra.SigninBuild
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.Query
  alias SigninappEx.Domain.Model.Signin.Model.SigninDto
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.ContextData

  @valid_msg "550e8400-e29b-41d4-a716-446655440000"
  @valid_xreq "550e8400-e29b-41d4-a716-446655440001"

  describe "build_query_with_dto/2" do
    test "happy path: builds query with dto when body and headers valid" do
      body = %{email: "user@example.com", password: "strongpass"}
      headers = %{MESSAGE_ID: @valid_msg, X_REQUEST_ID: @valid_xreq}

      assert {:ok, query} = SigninBuild.build_query_with_dto(body, headers)

      assert query.context == %ContextData{
               message_id: %MessageId{value: @valid_msg},
               x_request_id: %XRequestId{value: @valid_xreq}
             }

      assert query.payload == %SigninDto{
               email: %Email{value: "user@example.com"},
               password: %Password{value: "strongpass"}
             }
    end

    test "when MESSAGE_ID missing generates one and x_request_id defaults to it" do
      body = %{email: "user@example.com", password: "strongpass"}
      headers = %{}

      assert {:ok, query} = SigninBuild.build_query_with_dto(body, headers)

      assert !is_nil(query.context.message_id)
      assert query.context.x_request_id.value == query.context.message_id.value

      assert query.payload == %SigninDto{
               email: %Email{value: "user@example.com"},
               password: %Password{value: "strongpass"}
             }
    end

    test "returns error when message id is invalid" do
      body = %{email: "user@example.com", password: "StrongP@ssw0rd"}
      headers = %{MESSAGE_ID: "not-a-uuid"}

      assert {:error, :message_id_invalid_format} = SigninBuild.build_query_with_dto(body, headers)
    end

    test "returns error when x_request_id is invalid" do
      body = %{email: "user@example.com", password: "StrongP@ssw0rd"}
      headers = %{MESSAGE_ID: @valid_msg, X_REQUEST_ID: "invalid"}

      assert {:error, :x_request_id_invalid_format} = SigninBuild.build_query_with_dto(body, headers)
    end

    test "returns error when email is invalid format" do
      body = %{email: "userexample.com", password: "StrongP@ssw0rd"}
      headers = %{MESSAGE_ID: @valid_msg}

      assert {:error, %Query{payload: :email_invalid_format, context: %ContextData{}}} =
               SigninBuild.build_query_with_dto(body, headers)
    end

    test "returns error when email is missing" do
      body = %{password: "StrongP@ssw0rd"}
      headers = %{MESSAGE_ID: @valid_msg}

      assert {:error, %Query{payload: :email_empty, context: %ContextData{}}} =
               SigninBuild.build_query_with_dto(body, headers)
    end

    test "returns error when password is missing" do
      body = %{email: "user@example.com"}
      headers = %{MESSAGE_ID: @valid_msg}

      assert {:error, %Query{payload: :password_empty, context: %ContextData{}}} =
               SigninBuild.build_query_with_dto(body, headers)
    end

    test "returns error when email has invalid type (charlist)" do
      body = %{email: ["u", "s", "e", "r", "@", "e", "x", "a", "m", "p", "l", "e"], password: "StrongP@ssw0rd"}
      headers = %{MESSAGE_ID: @valid_msg}

      assert {:error, %Query{payload: :email_invalid_type, context: %ContextData{}}} =
               SigninBuild.build_query_with_dto(body, headers)
    end
  end
end
