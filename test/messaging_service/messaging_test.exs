defmodule MessagingService.MessagingTest do
  use MessagingService.DataCase

  alias MessagingService.Messaging

  describe "messages" do
    alias MessagingService.Messaging.Message

    import MessagingService.MessagingFixtures

    @invalid_attrs %{
      type: nil,
      body: nil,
      to: nil,
      from: nil,
      provider: nil,
      attachments: nil,
      provider_message_id: nil
    }
  end
end
