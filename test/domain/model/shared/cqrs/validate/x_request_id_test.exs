defmodule SigninappEx.Domain.Model.Shared.Cqrs.Validate.XRequestIdTest do
  use ExUnit.Case

  alias SigninappEx.Domain.Model.Shared.Cqrs.Validate.XRequestId

  describe "Happy path" do
    test "accepts a valid v4 UUID" do
      uuid = "550e8400-e29b-41d4-a716-446655440000"
      assert {:ok, req_id} = XRequestId.new(uuid)
      assert req_id.value == uuid
      assert XRequestId.value(req_id) == uuid
    end

    test "accepts uppercase hex UUIDs (case-insensitive)" do
      uuid = "550E8400-E29B-41D4-A716-446655440000"
      assert {:ok, req_id} = XRequestId.new(uuid)
      assert req_id.value == uuid
      assert XRequestId.value(req_id) == uuid
    end
  end

  describe "Error paths" do
    test "rejects nil with :x_request_id_empty" do
      assert {:error, :x_request_id_empty} = XRequestId.new(nil)
    end

    test "rejects empty string as invalid format" do
      assert {:error, :x_request_id_invalid_format} = XRequestId.new("")
    end

    test "rejects UUIDs with wrong version (not 4)" do
      # change the version nibble (the 13th hex digit in canonical form)
      uuid = "550e8400-e29b-11d4-a716-446655440000"
      assert {:error, :x_request_id_invalid_format} = XRequestId.new(uuid)
    end

    test "rejects UUIDs with invalid variant" do
      # variant nibble should be one of 8,9,a,b
      uuid = "550e8400-e29b-41d4-2716-446655440000"
      assert {:error, :x_request_id_invalid_format} = XRequestId.new(uuid)
    end

    test "rejects UUIDs without hyphens" do
      uuid = "550e8400e29b41d4a716446655440000"
      assert {:error, :x_request_id_invalid_format} = XRequestId.new(uuid)
    end

    test "rejects UUIDs with leading/trailing whitespace" do
      uuid = " 550e8400-e29b-41d4-a716-446655440000 "
      assert {:error, :x_request_id_invalid_format} = XRequestId.new(uuid)
    end

    test "rejects non-binary types" do
      assert {:error, :x_request_id_invalid_type} = XRequestId.new(123)
      assert {:error, :x_request_id_invalid_type} = XRequestId.new(:uuid)

      assert {:error, :x_request_id_invalid_type} =
               XRequestId.new({"550e8400-e29b-41d4-a716-446655440000"})

      assert {:error, :x_request_id_invalid_type} = XRequestId.new(["5", "5"])

      assert {:error, :x_request_id_invalid_type} =
               XRequestId.new(%{id: "550e8400-e29b-41d4-a716-446655440000"})
    end
  end
end
