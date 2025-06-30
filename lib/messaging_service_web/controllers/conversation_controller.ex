defmodule MessagingServiceWeb.ConversationController do
  use MessagingServiceWeb, :controller
  alias MessagingService.Messaging

  action_fallback MessagingServiceWeb.FallbackController

  def index(conn, _params) do
    conversations = Messaging.get_conversations()
    render(conn, "index.json", conversations: conversations)
  end

  def show(conn, %{"id" => id}) do
    # TODO: Add authorization check, ensure user is part of the conversation
    case Messaging.get_conversation(id) do
      {:ok, conversation} ->
        render(conn, "show.json", conversation: conversation)

      {:error, :not_found} ->
        {:error, :not_found}
    end
  end
end
