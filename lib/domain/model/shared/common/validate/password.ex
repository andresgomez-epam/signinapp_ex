defmodule Domain.Model.Shared.Common.Validate.Password do
  @moduledoc """
  Module that represents an email that only allows valid email formats.
  """

  defstruct [:value]

  @type t :: %__MODULE__{value: String.t()}

  @spec new(any()) :: {:ok, t()} | {:error, :invalid_password}
  def new(pass) when is_binary(pass) do
    if valid_password?(pass) do
      {:ok, %__MODULE__{value: pass}}
    else
      {:error, :invalid_password}
    end
  end
  def new(_), do: {:error, :invalid_password}

  @spec value(t()) :: String.t()
  def value(%__MODULE__{value: value}), do: value

  @spec valid_password?(String.t()) :: boolean()
  defp valid_password?(pass) do
    String.length(pass) >= 8
  end
end
