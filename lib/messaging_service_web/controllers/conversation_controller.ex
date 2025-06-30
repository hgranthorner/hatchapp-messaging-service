defmodule MessagingServiceWeb.ConversationController do
  use MessagingServiceWeb, :controller
  alias MessagingService.Messaging

  def index(conn, _params) do
    conversations = Messaging.get_conversations()
    render(conn, "index.json", conversations: conversations)
  end

  def show(conn, %{"id" => id}) do
    {:ok, conversation} = Messaging.get_conversation(id)
    render(conn, "show.json", conversation: conversation)
  end
end
