defmodule MessagingService.MessagingTest do
  alias Ecto.UUID
  use MessagingService.DataCase, async: true

  alias MessagingService.Messaging
  import MessagingService.MessagingFixtures

  describe "messages" do
    import MessagingService.MessagingFixtures

    test "sms" do
      {:ok, message} =
        Messaging.insert_text(sms_attrs())

      assert message.from == sms_attrs()["from"]
      assert message.provider_message_id == sms_attrs()["messaging_provider_id"]
      assert message.provider.name == "messaging_provider"
    end

    test "mms" do
      {:ok, message} =
        Messaging.insert_text(mms_attrs())

      assert message.from == mms_attrs()["from"]
      assert message.provider_message_id == mms_attrs()["messaging_provider_id"]
      assert message.provider.name == "messaging_provider"
    end

    test "email" do
      {:ok, message} =
        Messaging.insert_email(email_attrs())

      assert message.from == email_attrs()["from"]
      assert message.provider_message_id == email_attrs()["xillio_id"]
      assert message.provider.name == "xillio"
    end
  end

  describe "conversations" do
    test "creates a conversation when necessary" do
      from = UUID.generate()
      to = UUID.generate()

      # TODO(grant): move this to a fixture?
      {:ok, message} =
        sms_attrs()
        |> Map.put("from", from)
        |> Map.put("to", to)
        |> Messaging.insert_text()

      {:ok, conversation} = Messaging.get_conversation(message.conversation_id)
      conversation_message = conversation.messages |> List.first()
      assert conversation_message.id == message.id
    end

    test "reuses existing conversations when applicable" do
      from = UUID.generate()
      to = UUID.generate()

      {:ok, _} =
        sms_attrs()
        |> Map.put("from", from)
        |> Map.put("to", to)
        |> Messaging.insert_text()

      {:ok, message} =
        sms_attrs()
        |> Map.put("from", from)
        |> Map.put("to", to)
        |> Messaging.insert_text()

      {:ok, conversation} = Messaging.get_conversation(message.conversation_id)
      assert conversation.messages |> Enum.count() == 2
    end
  end
end
