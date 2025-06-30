defmodule MessagingServiceWeb.ConversationJSON do
  alias MessagingServiceWeb.MessageJSON
  alias MessagingService.Messaging.Conversation

  def index(%{conversations: conversations}) do
    %{data: Enum.map(conversations, &data/1)}
  end

  def show(%{conversation: conversation}) do
    %{data: data(conversation, include_messages: true)}
  end

  defp data(%Conversation{} = conversation, opts \\ []) do
    include_messages = Keyword.get(opts, :include_messages, false)
    c = %{id: conversation.id, participants: [conversation.user_1, conversation.user_2]}

    if include_messages do
      Map.put(c, :messages, Enum.map(conversation.messages, &MessageJSON.data/1))
    else
      c
    end
  end
end
