defmodule MessagingServiceWeb.EmailController do
  use MessagingServiceWeb, :controller
  alias MessagingService.Messaging

  def incoming(conn, params) do
    # TODO: forward message to user
    Messaging.insert_email(params)
    send_resp(conn, 200, "OK")
  end

  def outgoing(conn, params) do
    # TODO: forward message to provider
    Messaging.insert_email(params)
    send_resp(conn, 200, "OK")
  end
end
