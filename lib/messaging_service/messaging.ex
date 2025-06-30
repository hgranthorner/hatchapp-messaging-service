defmodule MessagingService.Messaging do
  @moduledoc """
  The Messaging context.
  """

  import Ecto.Query, warn: false
  alias MessagingService.Repo

  alias MessagingService.Messaging.Message
  alias MessagingService.Messaging.Conversation

  @spec insert_text(map()) :: {:ok, Message.t()} | {:error, Ecto.Changeset.t()}
  def insert_text(%{} = params) do
    with {:ok, conversation} <- lookup_conversation(params["from"], params["to"]),
         params = Map.put(params, "conversation_id", conversation.id) do
      %Message{}
      |> Message.text_changeset(params)
      |> Repo.insert()
    end
  end

  @spec insert_email(map()) :: {:ok, Message.t()} | {:error, Ecto.Changeset.t()}
  def insert_email(%{} = params) do
    with {:ok, conversation} <- lookup_conversation(params["from"], params["to"]),
         params = Map.put(params, "conversation_id", conversation.id) do
      %Message{}
      |> Message.email_changeset(params)
      |> Repo.insert()
    end
  end

  @spec lookup_conversation(String.t(), String.t()) ::
          {:ok, Conversation.t()} | {:error, Ecto.Changeset.t()}
  def lookup_conversation(from, to) do
    query =
      from c in Conversation,
        where: (c.user_1 == ^from and c.user_2 == ^to) or (c.user_1 == ^to and c.user_2 == ^from),
        select: c

    case Repo.one(query) do
      nil ->
        Repo.insert(Conversation.changeset(%Conversation{}, %{"user_1" => from, "user_2" => to}))

      c ->
        {:ok, c}
    end
  end
end
