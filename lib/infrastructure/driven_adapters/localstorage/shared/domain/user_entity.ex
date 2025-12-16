defmodule SigninappEx.Infrastructure.DrivenAdapters.Localstorage.Shared.Domain.UserEntity do
  defstruct [:email, :password, :name]

  @type t :: %__MODULE__{
          email: String.t(),
          password: String.t(),
          name: String.t() | nil
        }
end
