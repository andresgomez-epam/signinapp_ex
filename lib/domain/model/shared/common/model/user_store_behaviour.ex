defmodule SigninappEx.Domain.Model.Shared.Common.Model.UserStoreBehaviour do
  @moduledoc """
  Behaviour for user storage implementations.

  Implementations (in-memory, DB-backed, etc.) should implement these callbacks so they can be swapped
  in configuration or tests.
  """

  alias SigninappEx.Infrastructure.DrivenAdapters.Localstorage.Shared.Domain.UserEntity

  @callback put(UserEntity.t()) :: {:ok, UserEntity.t()} | {:error, :already_exists} | {:error, any()}
  @callback get(String.t()) :: UserEntity.t() | nil
  @callback list() :: [UserEntity.t()]
  @callback update(String.t(), (UserEntity.t() | nil -> UserEntity.t() | {:error, any()})) :: {:ok, UserEntity.t()} | {:error, any()}
  @callback delete(String.t()) :: :ok | {:error, any()}
end
