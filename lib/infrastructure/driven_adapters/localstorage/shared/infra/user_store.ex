defmodule SigninappEx.Infrastructure.DrivenAdapters.Localstorage.Shared.Infra.UserStore do
  @behaviour SigninappEx.Domain.Model.Shared.Common.Model.UserStoreBehaviour
  @moduledoc """
  In-memory, concurrency-safe store for `UserEntity` values.

  Implementation details:
  - Uses an ETS table for fast concurrent reads/writes (read_concurrency and write_concurrency enabled).
  - A GenServer manages the ETS table and serializes compound operations (e.g. update that depends on current value).

  API:
  - start_link/1
  - put/1
  - get/1
  - list/0
  - update/2
  - delete/1
  - clear/0 (test helper)
  """

  use GenServer

  alias SigninappEx.Infrastructure.DrivenAdapters.Localstorage.Shared.Domain.UserEntity

  @table_name :signinapp_ex_user_store

  # Public API
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: Keyword.get(opts, :name, __MODULE__))
  end

  @doc "Insert a `UserEntity` keyed by email. Fails if the email already exists."
  @spec put(UserEntity.t()) :: {:ok, UserEntity.t()} | {:error, :already_exists} | {:error, any()}
  @impl true
  def put(%UserEntity{email: email} = user) when is_binary(email) do
    GenServer.call(__MODULE__, {:put, email, user})
  end

  @doc "Get a user by email or nil if not found."
  @spec get(String.t()) :: UserEntity.t() | nil
  @impl true
  def get(email) when is_binary(email) do
    case :ets.lookup(@table_name, email) do
      [{^email, user}] -> user
      [] -> nil
    end
  end

  @doc "List all users."
  @spec list() :: [UserEntity.t()]
  @impl true
  def list do
    :ets.tab2list(@table_name) |> Enum.map(fn {_k, v} -> v end)
  end

  @doc """
  Atomically update a user identified by email.

  The updater fun will receive the current user (or nil) and should return the new user or `{:error, reason}`.
  """
  @spec update(String.t(), (UserEntity.t() | nil -> UserEntity.t() | {:error, any()})) ::
          {:ok, UserEntity.t()} | {:error, any()}
  @impl true
  def update(email, fun) when is_binary(email) and is_function(fun, 1) do
    GenServer.call(__MODULE__, {:update, email, fun})
  end

  @doc "Delete a user by email."
  @spec delete(String.t()) :: :ok | {:error, any()}
  @impl true
  def delete(email) when is_binary(email) do
    GenServer.call(__MODULE__, {:delete, email})
  end

  @doc "Clear the store (test helper)."
  @spec clear() :: :ok
  def clear do
    GenServer.call(__MODULE__, :clear)
  end

  # GenServer callbacks
  @impl true
  def init(_opts) do
    # Using protected so callers that know the table can read directly, while writes go through table ops
    table =
      :ets.new(@table_name, [
        :set,
        :protected,
        :named_table,
        read_concurrency: true,
        write_concurrency: true
      ])

    {:ok, table}
  end

  @impl true
  def handle_call({:update, email, fun}, _from, table) do
    current =
      case :ets.lookup(table, email) do
        [{^email, user}] -> user
        [] -> nil
      end

    case fun.(current) do
      {:error, _} = err ->
        {:reply, err, table}

      %UserEntity{} = new_user ->
        :ets.insert(table, {email, new_user})
        {:reply, {:ok, new_user}, table}

      other ->
        {:reply, {:error, {:invalid_return, other}}, table}
    end
  end

  @impl true
  def handle_call({:put, email, user}, _from, table) do
    case :ets.insert_new(table, {email, user}) do
      true -> {:reply, {:ok, user}, table}
      false -> {:reply, {:error, :already_exists}, table}
    end
  end

  @impl true
  def handle_call({:delete, email}, _from, table) do
    :ets.delete(table, email)
    {:reply, :ok, table}
  end

  @impl true
  def handle_call(:clear, _from, table) do
    :ets.delete_all_objects(table)
    {:reply, :ok, table}
  end
end
