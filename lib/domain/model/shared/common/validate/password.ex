defmodule SigninappEx.Domain.Model.Shared.Common.Validate.Password do
  @moduledoc """
  Module that represents a password string with basic validation.
  """

  defstruct [:value]

  @type t :: %__MODULE__{value: String.t()}

  @spec new(any()) :: {:ok, t()} | {:error, :password_empty | :password_invalid_type}
  def new(pass) when is_binary(pass) do
    {:ok, %__MODULE__{value: pass}}
  end

  def new(nil), do: {:error, :password_empty}
  def new(_), do: {:error, :password_invalid_type}

  @spec value(t()) :: String.t()
  def value(%__MODULE__{value: value}), do: value
end
