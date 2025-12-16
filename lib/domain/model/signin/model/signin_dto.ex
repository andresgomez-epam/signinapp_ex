defmodule SigninappEx.Domain.Model.Signin.Model.SigninDto do
  @moduledoc """
  Data Transfer Object for user sign-in information.
  """

  alias SigninappEx.Domain.Model.Shared.Common.Validate.Email
  alias SigninappEx.Domain.Model.Shared.Common.Validate.Password

  defstruct [:email, :password]

  @type t :: %__MODULE__{
          email: Email.t(),
          password: Password.t()
        }

  @spec new(any(), any()) ::
          {:error,
           :email_empty
           | :email_invalid_format
           | :email_invalid_type
           | :password_empty
           | :password_invalid_type
           | :password_weak}
          | {:ok, SigninappEx.Domain.Model.Signin.Model.SigninDto.t()}
  def new(email, password) do
    with {:ok, new_email} <- Email.new(email),
         {:ok, new_password} <- Password.new(password) do
      {:ok,
       %__MODULE__{
         email: new_email,
         password: new_password
       }}
    else
      error -> error
    end
  end
end
