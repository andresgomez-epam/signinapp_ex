defmodule SigninappEx.Domain.Model.Shared.Common.Validate.NameTest do
  use ExUnit.Case

  alias SigninappEx.Domain.Model.Shared.Common.Validate.Name

  describe "happy path" do
    test "accepts a valid name string" do
      assert {:ok, name} = Name.new("John Doe")
      assert name.value == "John Doe"
    end

    test "accepts a name with special characters" do
      assert {:ok, name} = Name.new("Anne-Marie O'Neill")
      assert name.value == "Anne-Marie O'Neill"
    end

    test "accepts a name with accents" do
      assert {:ok, name} = Name.new("José Ángel")
      assert name.value == "José Ángel"
    end

    test "accepts a nil" do
      assert {:ok, name} = Name.new(nil)
      assert name.value == nil
    end
  end

  describe "error path" do
    test "rejects a non-string name (integer)" do
      assert {:error, :name_invalid_type} = Name.new(12345)
    end

    test "rejects a non-string name (list)" do
      assert {:error, :name_invalid_type} = Name.new(['J', 'o', 'h', 'n'])
    end
  end
end
