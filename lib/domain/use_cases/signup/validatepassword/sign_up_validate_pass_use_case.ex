defmodule Domain.UseCases.Signup.Validatepassword.SignUpValidatePassUseCase do
  @moduledoc """
  Use case for validating a password during sign-up.
  """

  alias SigninappEx.Domain.Model.Shared.Cqrs.Model.Query

  @spec validate_password(%Query{
          :context => any(),
          :payload => binary()
        }) :: {:ok, :password_valid} | {:error, :password_weak}
  def validate_password(%Query{payload: password, context: _context}) when is_binary(password) do
    case strong_pass?(password) do
      true -> {:ok, :password_valid}
      false -> {:error, :password_weak}
    end
  end

  @spec strong_pass?(String.t()) :: boolean()
  defp strong_pass?(pass) do
    String.length(pass) >= 8
  end
end
