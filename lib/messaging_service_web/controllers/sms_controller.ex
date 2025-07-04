defmodule MessagingServiceWeb.SmsController do
  use MessagingServiceWeb, :controller
  alias MessagingService.Messaging

  action_fallback MessagingServiceWeb.FallbackController

  def incoming(conn, params) do
    with {:ok, message} <- Messaging.insert_text(params) do
      json(conn, %{data: %{message_id: message.id}})
    end
  end

  def outgoing(conn, params) do
    with {:ok, message} <- Messaging.insert_text(params) do
      # NOTE(grant): In a production application, if this fails we would want to track that and update the status of the message
      # and communicate that clearly to the user.
      Messaging.send_message_to_provider(message)
      json(conn, %{data: %{message_id: message.id}})
    else
      {:error, changeset_or_reason} ->
        {:error, changeset_or_reason}
    end
  end
end
