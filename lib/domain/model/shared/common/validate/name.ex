defmodule Signinapp.Model.Shared.Common.Validate.Name do
  @moduledoc """
  Module that represents a name string with no further validation.
  """

  defstruct [:value]

  @type t :: %__MODULE__{value: String.t()}

  @spec new(any()) :: {:ok, t()} | {:error, :invalid_name}
  def new(name) when is_binary(name) do
    {:ok, %__MODULE__{value: name}}
  end
  def new(nil), do: {:ok, %__MODULE__{value: nil}}
  def new(_), do: {:error, :invalid_name}

  @spec value(t()) :: String.t()
  def value(%__MODULE__{value: value}), do: value
end
