defmodule MessagingService.MessagingTest do
  use MessagingService.DataCase

  alias MessagingService.Messaging

  describe "messages" do
    import MessagingService.MessagingFixtures

    test "sms" do
      attrs = %{
        "from" => "+18045551234",
        "to" => "+12016661234",
        "type" => "sms",
        "messaging_provider_id" => "message-1",
        "body" => "text message",
        "attachments" => nil,
        # UTC timestamp
        "timestamp" => "2024-11-01T14:00:00Z"
      }

      {:ok, message} =
        Messaging.insert_text(attrs)

      assert message.from == attrs["from"]
      assert message.provider_message_id == attrs["messaging_provider_id"]
      assert message.provider == "messaging_provider"
    end

    test "mms" do
      attrs = %{
        "from" => "+18045551234",
        "to" => "+12016661234",
        "type" => "mms",
        "messaging_provider_id" => "message-2",
        "body" => "text message",
        "attachments" => ["attachment-url"],
        "timestamp" => "2024-11-01T14:00:00Z"
      }

      {:ok, message} =
        Messaging.insert_text(attrs)

      assert message.from == attrs["from"]
      assert message.provider_message_id == attrs["messaging_provider_id"]
      assert message.attachments == attrs["attachments"]
      assert message.provider == "messaging_provider"
    end

    test "email" do
      attrs = %{
        "from" => "[user@usehatchapp.com](mailto:user@usehatchapp.com)",
        "to" => "[contact@gmail.com](mailto:contact@gmail.com)",
        "xillio_id" => "message-2",
        "body" => "<html><body>html is <b>allowed</b> here </body></html>",
        "attachments" => ["attachment-url"],
        "timestamp" => "2024-11-01T14:00:00Z"
      }

      {:ok, message} =
        Messaging.insert_email(attrs)

      assert message.from == attrs["from"]
      assert message.provider_message_id == attrs["xillio_id"]
      assert message.attachments == attrs["attachments"]
      assert message.provider == "xillio"
    end
  end
end
