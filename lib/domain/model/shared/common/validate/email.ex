defmodule Domain.Model.Shared.Common.Validate.Email do
  @moduledoc """
  Module that represents an email that only allows valid email formats.
  """

  @email_regex ~r/^[A-Za-z0-9._%+\-#\/]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,4}$/
  defstruct [:value]

  @type t :: %__MODULE__{value: String.t()}

  @spec new(any()) :: {:ok, t()} | {:error, :invalid_email}
  def new(email) when is_binary(email) do
    if valid_email?(email) do
      {:ok, %__MODULE__{value: email}}
    else
      {:error, :invalid_email}
    end
  end
  def new(_), do: {:error, :invalid_email}

  @spec value(t()) :: String.t()
  def value(%__MODULE__{value: value}), do: value

  @spec valid_email?(String.t()) :: boolean()
  defp valid_email?(email) do
    Regex.match?(@email_regex, email)
  end
end
