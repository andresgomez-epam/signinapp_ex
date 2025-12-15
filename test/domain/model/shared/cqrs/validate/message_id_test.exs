defmodule SigninappEx.Domain.Model.Shared.Cqrs.Validate.MessageIdTest do
  use ExUnit.Case

  alias SigninappEx.Domain.Model.Shared.Cqrs.Validate.MessageId

  describe "Happy path" do
    test "accepts a valid v4 UUID" do
      uuid = "550e8400-e29b-41d4-a716-446655440000"
      assert {:ok, msg_id} = MessageId.new(uuid)
      assert msg_id.value == uuid
      assert MessageId.value(msg_id) == uuid
    end

    test "accepts uppercase hex UUIDs (case-insensitive)" do
      uuid = "550E8400-E29B-41D4-A716-446655440000"
      assert {:ok, msg_id} = MessageId.new(uuid)
      assert msg_id.value == uuid
      assert MessageId.value(msg_id) == uuid
    end

  end

  describe "Error paths" do

    test "rejects nil with :message_id_empty" do
      assert {:error, :message_id_empty} = MessageId.new(nil)
    end

    test "rejects empty string as invalid format" do
      assert {:error, :message_id_invalid_format} = MessageId.new("")
    end

    test "rejects UUIDs with wrong version (not 4)" do
      # change the version nibble (the 13th hex digit in canonical form)
      uuid = "550e8400-e29b-11d4-a716-446655440000"
      assert {:error, :message_id_invalid_format} = MessageId.new(uuid)
    end

    test "rejects UUIDs with invalid variant" do
      # variant nibble should be one of 8,9,a,b
      uuid = "550e8400-e29b-41d4-2716-446655440000"
      assert {:error, :message_id_invalid_format} = MessageId.new(uuid)
    end

    test "rejects UUIDs without hyphens" do
      uuid = "550e8400e29b41d4a716446655440000"
      assert {:error, :message_id_invalid_format} = MessageId.new(uuid)
    end

    test "rejects UUIDs with leading/trailing whitespace" do
      uuid = " 550e8400-e29b-41d4-a716-446655440000 "
      assert {:error, :message_id_invalid_format} = MessageId.new(uuid)
    end

    test "rejects non-binary types" do
      assert {:error, :message_id_invalid_type} = MessageId.new(123)
      assert {:error, :message_id_invalid_type} = MessageId.new(:uuid)
      assert {:error, :message_id_invalid_type} = MessageId.new({"550e8400-e29b-41d4-a716-446655440000"})
      assert {:error, :message_id_invalid_type} = MessageId.new(['5', '5'])
      assert {:error, :message_id_invalid_type} = MessageId.new(%{id: "550e8400-e29b-41d4-a716-446655440000"})
    end
  end
end
