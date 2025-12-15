defmodule SigninappEx.Domain.Model.Shared.Cqrs.Model.Query do
  @moduledoc """
  Represent a Query.
  """
  defstruct [:payload, :context]
end
