defmodule SigninappEx.Domain.Model.Shared.Common.Validate.Password do
  @moduledoc """
  Module that represents a password that only allows valid password formats:
  - Minimum length of 8 characters
  """

  defstruct [:value]

  @type t :: %__MODULE__{value: String.t()}

  @spec new(String.t()) :: {:ok, t()} | {:error, :password_weak}
  def new(pass) when is_binary(pass) do
    case strong_pass?(pass) do
      true -> {:ok, %__MODULE__{value: pass}}
      false -> {:error, :password_weak}
    end
  end

  @spec new(nil) :: {:error, :password_empty}
  def new(nil), do: {:error, :password_empty}
  @spec new(any()) :: {:error, :password_invalid_type}
  def new(_), do: {:error, :password_invalid_type}

  @spec value(t()) :: String.t()
  def value(%__MODULE__{value: value}), do: value

  @spec strong_pass?(String.t()) :: boolean()
  defp strong_pass?(pass) do
    String.length(pass) >= 8
  end
end
