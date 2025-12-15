defmodule SigninappEx.Domain.Model.Shared.Common.Validate.Name do
  @moduledoc """
  Module that represents a name string with no further validation.
  """

  defstruct [:value]

  @type t :: %__MODULE__{value: String.t()}

  @spec new(String.t()) :: {:ok, t()}
  def new(name) when is_binary(name) do
    {:ok, %__MODULE__{value: name}}
  end
  @spec new(nil) :: {:ok, t()}
  def new(nil), do: {:ok, %__MODULE__{value: nil}}
  @spec new(any()) :: {:error, :name_invalid_type}
  def new(_), do: {:error, :name_invalid_type}

  @spec value(t()) :: String.t()
  def value(%__MODULE__{value: value}), do: value
end
