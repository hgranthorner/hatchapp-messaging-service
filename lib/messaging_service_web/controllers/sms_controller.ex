defmodule MessagingServiceWeb.SmsController do
  use MessagingServiceWeb, :controller
  alias MessagingService.Messaging

  def incoming(conn, params) do
    # TODO: forward message to user
    # TODO: validate incoming message comes from provider
    Messaging.insert_text(params)
    send_resp(conn, 200, "OK")
  end

  def outgoing(conn, params) do
    # TODO: forward message to provider
    Messaging.insert_text(params)
    send_resp(conn, 200, "OK")
  end
end
