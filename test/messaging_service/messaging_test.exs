defmodule MessagingService.MessagingTest do
  alias Ecto.UUID
  use MessagingService.DataCase

  alias MessagingService.Messaging

  @sms_attrs %{
    "from" => "+18045551234",
    "to" => "+12016661234",
    "type" => "sms",
    "messaging_provider_id" => "message-1",
    "body" => "text message",
    "attachments" => nil,
    "timestamp" => "2024-11-01T14:00:00Z"
  }

  @mms_attrs %{
    "from" => "+18045551234",
    "to" => "+12016661234",
    "type" => "mms",
    "messaging_provider_id" => "message-2",
    "body" => "text message",
    "attachments" => ["attachment-url"],
    "timestamp" => "2024-11-01T14:00:00Z"
  }

  @email_attrs %{
    "from" => "[user@usehatchapp.com](mailto:user@usehatchapp.com)",
    "to" => "[contact@gmail.com](mailto:contact@gmail.com)",
    "xillio_id" => "message-2",
    "body" => "<html><body>html is <b>allowed</b> here </body></html>",
    "attachments" => ["attachment-url"],
    "timestamp" => "2024-11-01T14:00:00Z"
  }

  describe "messages" do
    import MessagingService.MessagingFixtures

    test "sms" do
      {:ok, message} =
        Messaging.insert_text(@sms_attrs)

      assert message.from == @sms_attrs["from"]
      assert message.provider_message_id == @sms_attrs["messaging_provider_id"]
      assert message.provider == "messaging_provider"
    end

    test "mms" do
      {:ok, message} =
        Messaging.insert_text(@mms_attrs)

      assert message.from == @mms_attrs["from"]
      assert message.provider_message_id == @mms_attrs["messaging_provider_id"]
      assert message.attachments == @mms_attrs["attachments"]
      assert message.provider == "messaging_provider"
    end

    test "email" do
      {:ok, message} =
        Messaging.insert_email(@email_attrs)

      assert message.from == @email_attrs["from"]
      assert message.provider_message_id == @email_attrs["xillio_id"]
      assert message.attachments == @email_attrs["attachments"]
      assert message.provider == "xillio"
    end
  end

  describe "conversations" do
    test "creates a conversation when necessary" do
      from = UUID.generate()
      to = UUID.generate()

      # TODO(grant): move this to a fixture?
      {:ok, message} =
        @sms_attrs
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
        @sms_attrs
        |> Map.put("from", from)
        |> Map.put("to", to)
        |> Messaging.insert_text()

      {:ok, message} =
        @sms_attrs
        |> Map.put("from", from)
        |> Map.put("to", to)
        |> Messaging.insert_text()

      {:ok, conversation} = Messaging.get_conversation(message.conversation_id)
      assert conversation.messages |> Enum.count() == 2
    end
  end
end
