defmodule MessagingServiceWeb.MessageJSON do
  alias MessagingService.Messaging.Message

  @doc """
  Renders a list of messages.
  """
  def index(%{messages: messages}) do
    %{data: for(message <- messages, do: data(message))}
  end

  @doc """
  Renders a single message.
  """
  def show(%{message: message}) do
    %{data: data(message)}
  end

  def data(%Message{} = message) do
    attachments =
      if message.type == :sms do
        nil
      else
        for(%{url: url} <- message.attachments, do: url)
      end

    %{
      id: message.id,
      from: message.from,
      to: message.to,
      type: message.type,
      body: message.body,
      attachments: attachments,
      provider: message.provider.name,
      provider_message_id: message.provider_message_id
    }
  end
end
