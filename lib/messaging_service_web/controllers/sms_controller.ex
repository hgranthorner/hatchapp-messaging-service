defmodule MessagingServiceWeb.SmsController do
  use MessagingServiceWeb, :controller
  alias MessagingService.Messaging

  def incoming(conn, params) do
    # TODO: forward message to user
    # TODO: validate incoming message comes from provider
    # validate_incoming_message(conn, params)
    Messaging.insert_text(params)
    # send_message_to_user(params)
    send_resp(conn, 200, "OK")
  end

  def outgoing(conn, params) do
    # TODO: forward message to provider
    Messaging.insert_text(params)
    send_resp(conn, 200, "OK")
  end

  # def provider_send_message(message) do
  #   case [200, 429, 500] do
  #     200 -> :ok
  #     429 -> retry()
  #     500 -> :error
  #   end
  # end
end
