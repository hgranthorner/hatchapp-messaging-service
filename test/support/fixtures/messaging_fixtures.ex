defmodule MessagingService.MessagingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MessagingService.Messaging` context.
  """
  def sms_attrs,
    do: %{
      "from" => "+18045551234",
      "to" => "+12016661234",
      "type" => "sms",
      "messaging_provider_id" => "message-1",
      "body" => "text message",
      "attachments" => nil,
      "timestamp" => "2024-11-01T14:00:00Z"
    }

  def mms_attrs,
    do: %{
      "from" => "+18045551234",
      "to" => "+12016661234",
      "type" => "mms",
      "messaging_provider_id" => "message-2",
      "body" => "text message",
      "attachments" => ["attachment-url"],
      "timestamp" => "2024-11-01T14:00:00Z"
    }

  def email_attrs,
    do: %{
      "from" => "[user@usehatchapp.com](mailto:user@usehatchapp.com)",
      "to" => "[contact@gmail.com](mailto:contact@gmail.com)",
      "xillio_id" => "message-2",
      "body" => "<html><body>html is <b>allowed</b> here </body></html>",
      "attachments" => ["attachment-url"],
      "timestamp" => "2024-11-01T14:00:00Z"
    }
end
