defmodule SigninappEx.Domain.UseCases.Signup.Validatepassword.SignUpValidatePassUseCaseTest do
  use ExUnit.Case, async: true

  alias SigninappEx.Domain.UseCases.Signup.Validatepassword.SignUpValidatePassUseCase
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.Query
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.ContextData

  describe "validate_password/1" do
    test "returns :password_valid for a strong password" do
      {:ok, context} =
        ContextData.new(
          "550e8400-e29b-41d4-a716-446655440000",
          "550e8400-e29b-41d4-a716-446655440001"
        )

      query = %Query{payload: "StrongP@ssw0rd", context: context}

      assert {:ok, :password_valid} ==
               SignUpValidatePassUseCase.validate_password(query)
    end

    test "returns :password_weak for a weak password" do
      {:ok, context} =
        ContextData.new(
          "550e8400-e29b-41d4-a716-446655440000",
          "550e8400-e29b-41d4-a716-446655440001"
        )

      query = %Query{payload: "short", context: context}

      assert {:error, :password_weak} ==
               SignUpValidatePassUseCase.validate_password(query)
    end
  end
end
