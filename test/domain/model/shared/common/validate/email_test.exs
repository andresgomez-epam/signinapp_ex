defmodule Domain.Model.Shared.Common.Validate.EmailTest do
  use ExUnit.Case

  alias Domain.Model.Shared.Common.Validate.Email

  describe "happy path for Email.new/1" do
      test "accepts a valid email address" do
        assert {:ok, email} = Email.new("user@example.com")
        assert email.value == "user@example.com"
      end

      test "accepts email with numbers" do
        assert {:ok, email} = Email.new("user123@example456.com")
        assert email.value == "user123@example456.com"
      end

      test "accepts email with dots in local part" do
        assert {:ok, email} = Email.new("first.last@example.com")
        assert email.value == "first.last@example.com"
      end

      test "accepts email with plus sign" do
        assert {:ok, email} = Email.new("user+tag@example.com")
        assert email.value == "user+tag@example.com"
      end

      test "accepts email with hyphen" do
        assert {:ok, email} = Email.new("user-name@example.com")
        assert email.value == "user-name@example.com"
      end

      test "accepts email with underscore" do
        assert {:ok, email} = Email.new("user_name@example.com")
        assert email.value == "user_name@example.com"
      end

      test "accepts email with percent sign" do
        assert {:ok, email} = Email.new("user%name@example.com")
        assert email.value == "user%name@example.com"
      end

      test "accepts email with hash sign" do
        assert {:ok, email} = Email.new("user#name@example.com")
        assert email.value == "user#name@example.com"
      end

      test "accepts email with slash" do
        assert {:ok, email} = Email.new("user/name@example.com")
        assert email.value == "user/name@example.com"
      end

      test "accepts email with subdomain" do
        assert {:ok, email} = Email.new("user@mail.example.com")
        assert email.value == "user@mail.example.com"
      end

      test "accepts email with uppercase letters" do
        assert {:ok, email} = Email.new("User@Example.COM")
        assert email.value == "User@Example.COM"
      end
    end

    describe "nil email" do
      test "rejects nil" do
        assert {:error, :email_invalid_format} = Email.new(nil)
      end
    end

    describe "empty string email" do
      test "rejects empty string" do
        assert {:error, :email_invalid_format} = Email.new("")
      end

      test "rejects string with only spaces" do
        assert {:error, :email_invalid_format} = Email.new("   ")
      end
    end

    describe "invalid format email - no @" do
      test "rejects email without @ symbol" do
        assert {:error, :email_invalid_format} = Email.new("userexample.com")
      end

      test "rejects email with multiple @ symbols" do
        assert {:error, :email_invalid_format} = Email.new("user@@example.com")
      end

      test "rejects email with @ at the beginning" do
        assert {:error, :email_invalid_format} = Email.new("@example.com")
      end

      test "rejects email with @ at the end" do
        assert {:error, :email_invalid_format} = Email.new("user@")
      end
    end

    describe "invalid format email - no dot in domain" do
      test "rejects email without dot in domain" do
        assert {:error, :email_invalid_format} = Email.new("user@example")
      end

      test "rejects email with dot but invalid domain structure" do
        assert {:error, :email_invalid_format} = Email.new("user@.com")
      end

      test "rejects email with dot at the end of domain" do
        assert {:error, :email_invalid_format} = Email.new("user@example.")
      end
    end

    describe "invalid format email - invalid domain TLD" do
      test "rejects email with single letter TLD" do
        assert {:error, :email_invalid_format} = Email.new("user@example.c")
      end

      test "rejects email with TLD longer than 4 characters" do
        assert {:error, :email_invalid_format} = Email.new("user@example.toolong")
      end

      test "rejects email with numeric TLD" do
        assert {:error, :email_invalid_format} = Email.new("user@example.123")
      end

      test "rejects email with special characters in TLD" do
        assert {:error, :email_invalid_format} = Email.new("user@example.co-m")
      end
    end

    describe "invalid format email - invalid local part" do
      test "rejects email with special characters not allowed" do
        assert {:error, :email_invalid_format} = Email.new("user¿name@example.com")
      end

      test "rejects email with space in local part" do
        assert {:error, :email_invalid_format} = Email.new("user name@example.com")
      end
    end

    describe "invalid format email - invalid domain part" do
      test "rejects email with special characters in domain" do
        assert {:error, :email_invalid_format} = Email.new("user@exam@ple.com")
      end

      test "rejects email with space in domain" do
        assert {:error, :email_invalid_format} = Email.new("user@exam ple.com")
      end
    end

    describe "invalid type - non-binary inputs" do
      test "rejects atom" do
        assert {:error, :email_invalid_format} = Email.new(:user_at_example_dot_com)
      end

      test "rejects integer" do
        assert {:error, :email_invalid_format} = Email.new(123)
      end

      test "rejects float" do
        assert {:error, :email_invalid_format} = Email.new(12.34)
      end

      test "rejects list" do
        assert {:error, :email_invalid_format} = Email.new(['user', '@', 'example.com'])
      end

      test "rejects map" do
        assert {:error, :email_invalid_format} = Email.new(%{"email" => "user@example.com"})
      end

      test "rejects tuple" do
        assert {:error, :email_invalid_format} = Email.new({"user", "@example.com"})
      end

      test "rejects boolean true" do
        assert {:error, :email_invalid_format} = Email.new(true)
      end

      test "rejects boolean false" do
        assert {:error, :email_invalid_format} = Email.new(false)
      end
    end
end
