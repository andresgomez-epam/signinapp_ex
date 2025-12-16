defmodule SigninappEx.Domain.Model.Shared.Common.Validate.Email do
  @moduledoc """
  Module that represents an email that only allows valid email formats.
  """

  @email_regex ~r/^[A-Za-z0-9._%+\-#\/]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,4}$/
  defstruct [:value]

  @type t :: %__MODULE__{value: String.t()}

  @spec new(String.t()) :: {:ok, t()} | {:error, :email_invalid_format}
  def new(email) when is_binary(email) do
    case Regex.match?(@email_regex, email) do
      true -> {:ok, %__MODULE__{value: email}}
      false -> {:error, :email_invalid_format}
    end
  end

  @spec new(nil) :: {:error, :email_empty}
  def new(nil), do: {:error, :email_empty}
  @spec new(any()) :: {:error, :email_invalid_type}
  def new(_), do: {:error, :email_invalid_type}

  @spec value(t()) :: String.t()
  def value(%__MODULE__{value: value}), do: value
end
