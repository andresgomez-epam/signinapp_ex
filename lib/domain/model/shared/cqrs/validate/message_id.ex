defmodule SigninappEx.Domain.Model.Shared.Cqrs.Validate.MessageId do
  @moduledoc """
  Represents a Message ID with UUID format
  """

  @uuid_regex ~r/^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i
  defstruct [:value]

  @type t :: %__MODULE__{value: String.t()}

  @spec new(any()) ::
          {:error, :message_id_empty | :message_id_invalid_format | :message_id_invalid_type}
          | {:ok, SigninappEx.Domain.Model.Shared.Cqrs.Validate.MessageId.t()}
  def new(message_id) when is_binary(message_id) do
    case Regex.match?(@uuid_regex, message_id) do
      true -> {:ok, %__MODULE__{value: message_id}}
      false -> {:error, :message_id_invalid_format}
    end
  end

  @spec new(nil) :: {:error, :message_id_empty}
  def new(nil), do: {:error, :message_id_empty}
  @spec new(any()) :: {:error, :message_id_invalid_type}
  def new(_), do: {:error, :message_id_invalid_type}

  @spec value(t()) :: String.t()
  def value(%__MODULE__{value: value}), do: value
end
