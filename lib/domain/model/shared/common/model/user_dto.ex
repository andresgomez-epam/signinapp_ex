defmodule SigninappEx.Domain.Model.Shared.Common.Model.UserDto do
  @moduledoc """
  Data Transfer Object for user information.
  """

  alias SigninappEx.Domain.Model.Shared.Common.Validate.Email
  alias SigninappEx.Domain.Model.Shared.Common.Validate.Password
  alias SigninappEx.Domain.Model.Shared.Common.Validate.Name

  defstruct [:email, :password, :name]

  @type t :: %__MODULE__{
          email: Email.t(),
          password: Password.t(),
          name: Name.t() | nil
        }

  @spec new(any(), any(), any()) ::
          {:error,
           :email_empty
           | :email_invalid_format
           | :email_invalid_type
           | :name_invalid_type
           | :password_empty
           | :password_invalid_type
           | :password_weak}
          | {:ok, SigninappEx.Domain.Model.Shared.Common.Model.UserDto.t()}
  def new(email, password, name) do
    with {:ok, new_email} <- Email.new(email),
         {:ok, new_password} <- Password.new(password),
         {:ok, new_name} <- Name.new(name) do
      {:ok,
       %__MODULE__{
         email: new_email,
         password: new_password,
         name: new_name
       }}
    else
      error -> error
    end
  end
end
