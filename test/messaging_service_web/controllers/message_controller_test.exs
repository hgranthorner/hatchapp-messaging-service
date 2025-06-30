defmodule MessagingServiceWeb.MessageControllerTest do
  use MessagingServiceWeb.ConnCase

  import MessagingService.MessagingFixtures

  alias MessagingService.Messaging.Message

  @create_attrs %{
    type: :sms,
    body: "some body",
    to: "some to",
    from: "some from",
    provider: "some provider",
    attachments: %{},
    provider_message_id: "some provider_message_id"
  }
  @update_attrs %{
    type: :mms,
    body: "some updated body",
    to: "some updated to",
    from: "some updated from",
    provider: "some updated provider",
    attachments: %{},
    provider_message_id: "some updated provider_message_id"
  }
  @invalid_attrs %{
    type: nil,
    body: nil,
    to: nil,
    from: nil,
    provider: nil,
    attachments: nil,
    provider_message_id: nil
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end
end
