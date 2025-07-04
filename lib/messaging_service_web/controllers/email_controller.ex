defmodule MessagingServiceWeb.EmailController do
  use MessagingServiceWeb, :controller
  alias MessagingService.Messaging

  action_fallback MessagingServiceWeb.FallbackController

  def incoming(conn, params) do
    Messaging.insert_email(params)
    send_resp(conn, 200, "OK")
  end

  def outgoing(conn, params) do
    with {:ok, message} <- Messaging.insert_email(params) do
      Messaging.send_message_to_provider(message)
      send_resp(conn, 200, "OK")
    else
      {:error, changeset_or_reason} ->
        {:error, changeset_or_reason}
    end
  end
end
