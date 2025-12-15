defmodule SigninappEx.Domain.Model.Shared.Cqrs.Validate.XRequestId do
  @moduledoc """
  Represents a Message ID with UUID format
  """

  @uuid_regex ~r/^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i
  defstruct [:value]

  @type t :: %__MODULE__{value: String.t()}

  @spec new(any()) ::
          {:error,
           :x_request_id_empty | :x_request_id_invalid_format | :x_request_id_invalid_type}
          | {:ok, SigninappEx.Domain.Model.Shared.Cqrs.Validate.XRequestId.t()}
  def new(x_request_id) when is_binary(x_request_id) do
    case Regex.match?(@uuid_regex, x_request_id) do
      true -> {:ok, %__MODULE__{value: x_request_id}}
      false -> {:error, :x_request_id_invalid_format}
    end
  end
  @spec new(nil) :: {:error, :x_request_id_empty}
  def new(nil), do: {:error, :x_request_id_empty}
  @spec new(any()) :: {:error, :x_request_id_invalid_type}
  def new(_), do: {:error, :x_request_id_invalid_type}

  @spec value(t()) :: String.t()
  def value(%__MODULE__{value: value}), do: value
end
