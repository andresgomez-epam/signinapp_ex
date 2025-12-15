defmodule SigninappEx.Infrastructure.DrivenAdapters.Localstorage.Shared.Infra.UserStoreTest do
  use ExUnit.Case, async: false

  alias SigninappEx.Infrastructure.DrivenAdapters.Localstorage.Shared.{Infra.UserStore, Domain.UserEntity}

  setup do
    # Start the store process for each test to ensure isolation
    {:ok, _pid} = start_supervised(UserStore)
    :ok
  end

  test "put/get/list/delete basic ops" do
    user = %UserEntity{email: "a@example.com", password: "secret", name: "Alice"}
    assert {:ok, ^user} = UserStore.put(user)
    assert %UserEntity{email: "a@example.com"} = UserStore.get("a@example.com")
    assert [^user] = UserStore.list()

    assert :ok = UserStore.delete("a@example.com")
    assert nil == UserStore.get("a@example.com")
  end

  test "update is atomic and validates updater return" do
    user = %UserEntity{email: "b@example.com", password: "pw", name: "Bob"}
    assert {:ok, _} = UserStore.put(user)

    {:ok, updated} = UserStore.update("b@example.com", fn %UserEntity{} = current ->
      assert current.email == "b@example.com"
      %UserEntity{current | name: "Bobby"}
    end)

    assert updated.email == "b@example.com"
    assert updated.name == "Bobby"

    assert {:error, {:invalid_return, _}} = UserStore.update("b@example.com", fn _ -> :not_a_user end)

    # duplicate put is prevented
    assert {:error, :already_exists} = UserStore.put(user)
  end

  test "concurrent writes and reads" do
    n = 100

    tasks =
      for i <- 1..n do
        Task.async(fn ->
          u = %UserEntity{email: "user#{i}@example.com", password: "pw#{i}", name: "User#{i}"}
          UserStore.put(u)
          # read back
          assert UserStore.get(u.email).email == u.email
        end)
      end

    Enum.each(tasks, &Task.await(&1, 5_000))

    all = UserStore.list()
    assert length(all) == n
  end
end
