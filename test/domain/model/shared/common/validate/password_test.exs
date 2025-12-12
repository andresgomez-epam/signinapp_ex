defmodule Domain.Model.Shared.Common.Validate.PasswordTest do
  use ExUnit.Case

  alias Domain.Model.Shared.Common.Validate.Password

  describe "happy path for Password.new/1" do
      test "accepts a valid password with minimum length" do
        assert {:ok, password} = Password.new("strongpass")
        assert password.value == "strongpass"
      end

      test "accepts a valid password with special characters" do
        assert {:ok, password} = Password.new("P@ssw0rd!")
        assert password.value == "P@ssw0rd!"
      end

      test "accepts a valid password with numbers" do
        assert {:ok, password} = Password.new("pass1234")
        assert password.value == "pass1234"
      end

      test "accepts a valid password with mixed case letters" do
        assert {:ok, password} = Password.new("PaSsWoRd")
        assert password.value == "PaSsWoRd"
      end
  end

  describe "error path for Password.new/1" do
      test "rejects a password that is too short" do
        assert {:error, :invalid_password} = Password.new("short")
      end

      test "rejects an empty password" do
        assert {:error, :invalid_password} = Password.new("")
      end

      test "rejects a non-string password (integer)" do
        assert {:error, :invalid_password} = Password.new(12345678)
      end

      test "rejects a non-string password (nil)" do
        assert {:error, :invalid_password} = Password.new(nil)
      end

      test "rejects a non-string password (list)" do
        assert {:error, :invalid_password} = Password.new(['p','a','s','s'])
      end
  end
end
