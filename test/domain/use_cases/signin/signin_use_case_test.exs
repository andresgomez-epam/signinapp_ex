defmodule SigninappEx.Domain.UseCases.Signin.SigninUseCaseTest do
  use ExUnit.Case, async: true
  import Mock

  alias SigninappEx.Domain.UseCases.Signin.SigninUseCase
  alias SigninappEx.Domain.UseCases.Signin.Searchuser.SigninSearchUserUseCase
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.Query
  alias SigninappEx.Domain.Model.Signin.Model.SigninDto
  alias SigninappEx.Domain.Model.Shared.Common.Model.UserDto
  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.ContextData

  @signin_write_gateway SigninappEx.Infrastructure.DrivenAdapters.Localstorage.Signin.Application.SigninWriteGateway

  describe "execute_signin/1" do
    test "happy path: valid signin" do
      {:ok, signin_dto} = SigninDto.new("user@example.com", "StrongP@ssw0rd")
      {:ok, context} =
        ContextData.new(
          "550e8400-e29b-41d4-a716-446655440010",
          "550e8400-e29b-41d4-a716-446655440011"
        )

      query = %Query{payload: signin_dto, context: context}

      # user entity with matching password
      {:ok, user_dto} = UserDto.new("user@example.com", "StrongP@ssw0rd", "Name")

      with_mock SigninSearchUserUseCase,
        search_user: fn received_query ->
          # ensure the sub use case receives exactly the same query
          assert received_query == query
          {:ok, user_dto}
        end do
        with_mock @signin_write_gateway,
          # ensure the gateway receives exactly the same query
          sign_in: fn received_query ->
            assert received_query == query
            {:ok, %Query{payload: "some-uuid", context: context}}
          end do
          assert {:ok, %Query{payload: "some-uuid", context: ^context}} = SigninUseCase.execute_signin(query)
        end
      end
    end

    test "user does not exist" do
      {:ok, signin_dto} = SigninDto.new("noone@example.com", "StrongP@ssw0rd")
      {:ok, context} =
        ContextData.new(
          "550e8400-e29b-41d4-a716-446655440012",
          "550e8400-e29b-41d4-a716-446655440013"
        )

      query = %Query{payload: signin_dto, context: context}

      with_mock SigninSearchUserUseCase,
        search_user: fn received_query ->
          assert received_query == query
          {:error, :user_not_found}
        end do
        assert {:error, %Query{payload: :user_not_found, context: ^context}} = SigninUseCase.execute_signin(query)
      end
    end

    test "invalid credentials" do
      {:ok, signin_dto} = SigninDto.new("user@example.com", "WrongPassword")
      {:ok, context} =
        ContextData.new(
          "550e8400-e29b-41d4-a716-446655440014",
          "550e8400-e29b-41d4-a716-446655440015"
        )

      query = %Query{payload: signin_dto, context: context}

      # user entity with different password
      {:ok, user_dto} = UserDto.new("user@example.com", "CorrectP@ssw0rd", "Name")

      with_mock SigninSearchUserUseCase,
        search_user: fn received_query ->
          assert received_query == query
          {:ok, user_dto}
        end do
        assert {:error, %Query{payload: :invalid_credentials, context: ^context}} = SigninUseCase.execute_signin(query)
      end
    end
  end
end
