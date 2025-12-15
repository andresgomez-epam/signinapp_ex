defmodule SigninappEx.Domain.Model.Shared.Cqrs.Model.Command do
  @moduledoc """
  Represent a Command.
  """
  defstruct [:payload, :context]
end
