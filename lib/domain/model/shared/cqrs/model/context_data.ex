defmodule SigninappEx.Domain.Model.Shared.Cqrs.Model.ContextData do
  @moduledoc """
  Represent a ContextData.
  """
  alias SigninappEx.Domain.Model.Shared.Cqrs.Validate.MessageId
  alias SigninappEx.Domain.Model.Shared.Cqrs.Validate.XRequestId

  defstruct [:message_id, :x_request_id]

  @type t :: %__MODULE__{
          message_id: MessageId.t(),
          x_request_id: XRequestId.t()
        }

  def new(message_id, x_request_id) do
    with {:ok, new_message_id} <- MessageId.new(message_id),
         {:ok, new_x_request_id} <- resolve_x_request_id(message_id, x_request_id) do
      {:ok,
       %__MODULE__{
         message_id: new_message_id,
         x_request_id: new_x_request_id
       }}
    end
  end

  defp resolve_x_request_id(message_id, x_request_id) do
    case is_binary(x_request_id) and String.trim(x_request_id) != "" do
      true -> XRequestId.new(x_request_id)
      false -> XRequestId.new(message_id)
    end
  end
end
