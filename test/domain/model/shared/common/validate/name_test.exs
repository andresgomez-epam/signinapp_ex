defmodule Domain.Model.Shared.Common.Validate.NameTest do
  use ExUnit.Case

  alias Domain.Model.Shared.Common.Validate.Name

  describe "happy path for Name.new/1" do
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

  describe "error path for Name.new/1" do
      test "rejects a non-string name (integer)" do
        assert {:error, :invalid_name} = Name.new(12345)
      end

      test "rejects a non-string name (list)" do
        assert {:error, :invalid_name} = Name.new(['J','o','h','n'])
      end
  end
end
