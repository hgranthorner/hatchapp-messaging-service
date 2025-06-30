defmodule MessagingService.Messaging do
  @moduledoc """
  The main context for the application. We would want to also add an Account/Authorization context ASAP if this were a real application.
  """

  import Ecto.Query, warn: false
  alias MessagingService.Repo

  alias MessagingService.Messaging.Message
  alias MessagingService.Messaging.Conversation

  @doc """
  Insert a new SMS or MMS message into the database.
  """
  @spec insert_text(map()) :: {:ok, Message.t()} | {:error, Ecto.Changeset.t()}
  def insert_text(%{} = params) do
    Repo.transact(fn ->
      with {:ok, conversation} <- lookup_conversation(params["from"], params["to"]) do
        Ecto.build_assoc(conversation, :messages)
        |> Message.text_changeset(params)
        |> Repo.insert()
      end
    end)
  end

  @spec insert_email(map()) :: {:ok, Message.t()} | {:error, Ecto.Changeset.t()}
  def insert_email(%{} = params) do
    Repo.transact(fn ->
      with {:ok, conversation} <- lookup_conversation(params["from"], params["to"]),
           params = Map.put(params, "conversation_id", conversation.id) do
        %Message{}
        |> Message.email_changeset(params)
        |> Repo.insert()
      end
    end)
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

  def get_conversations() do
    Repo.all(Conversation)
  end

  @spec get_conversation(String.t()) :: {:ok, Conversation.t()} | {:error, :not_found}
  def get_conversation(conversation_id) do
    Repo.get(preload(Conversation, :messages), conversation_id)
    |> case do
      nil -> {:error, :not_found}
      conversation -> {:ok, conversation}
    end
  end
end
