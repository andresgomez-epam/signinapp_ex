defmodule SigninappEx.Domain.UseCases.Signin.Searchuser.SigninSearchUserUseCaseTest do
  use ExUnit.Case, async: false
  import Mock

  alias SigninappEx.Domain.UseCases.Signin.Searchuser.SigninSearchUserUseCase
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.Query
  alias SigninappEx.Domain.Model.Signin.Model.SigninDto
  alias SigninappEx.Domain.Model.Shared.Common.Model.UserDto
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.ContextData

  @signin_read_gateway SigninappEx.Infrastructure.DrivenAdapters.Localstorage.Signin.Application.SigninReadGateway

  describe "search_user/1" do
    test "returns user when gateway finds user" do
      {:ok, signin_dto} = SigninDto.new("user@example.com", "StrongP@ssw0rd")

      {:ok, context} =
        ContextData.new(
          "550e8400-e29b-41d4-a716-446655440000",
          "550e8400-e29b-41d4-a716-446655440001"
        )

      query = %Query{payload: signin_dto, context: context}

      {:ok, user_dto} = UserDto.new("user@example.com", "StrongP@ssw0rd", "Name")

      with_mock @signin_read_gateway,
        search_user: fn received_query ->
          assert received_query == query
          {:ok, user_dto}
        end do
        assert {:ok, user_dto} == SigninSearchUserUseCase.search_user(query)
      end
    end

    test "returns error when user not found" do
      {:ok, signin_dto} = SigninDto.new("noone@example.com", "StrongP@ssw0rd")

      {:ok, context} =
        ContextData.new(
          "550e8400-e29b-41d4-a716-446655440002",
          "550e8400-e29b-41d4-a716-446655440003"
        )

      query = %Query{payload: signin_dto, context: context}

      with_mock @signin_read_gateway,
        search_user: fn received_query ->
          assert received_query == query
          {:error, :user_not_found}
        end do
        assert {:error, :user_not_found} == SigninSearchUserUseCase.search_user(query)
      end
    end

    test "raises FunctionClauseError when argument does not match required pattern" do
      # Passing a plain map (not a %Query{}) should not match the function head
      assert_raise FunctionClauseError, fn ->
        SigninSearchUserUseCase.search_user(%{})
      end
    end
  end
end
