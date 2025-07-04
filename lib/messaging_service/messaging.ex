defmodule MessagingService.Messaging do
  @moduledoc """
  The main context for the application. We would want to also add an Account/Authorization context ASAP if this were a real application.
  """

  import Ecto.Query, warn: false
  alias MessagingService.Repo

  alias MessagingService.Messaging.Message
  alias MessagingService.Messaging.Conversation
  alias MessagingService.Messaging.Provider
  alias MessagingService.Provider, as: ProviderContext

  @doc """
  Insert a new SMS or MMS message into the database.
  """
  @spec insert_text(map()) :: {:ok, Message.t()} | {:error, Ecto.Changeset.t()}
  def insert_text(%{} = params) do
    Repo.transact(fn ->
      with {:ok, conversation} <- lookup_conversation(params["from"], params["to"]),
           {:ok, provider} <- get_provider(params) do
        params = put_attachments(params)

        Ecto.build_assoc(conversation, :messages)
        |> Map.put(:provider, provider)
        |> Message.text_changeset(params)
        |> Repo.insert()
      end
    end)
  end

  @spec insert_email(map()) :: {:ok, Message.t()} | {:error, Ecto.Changeset.t()}
  def insert_email(%{} = params) do
    Repo.transact(fn ->
      with {:ok, conversation} <- lookup_conversation(params["from"], params["to"]),
           {:ok, provider} <- get_provider(params) do
        params = put_attachments(params)

        Ecto.build_assoc(conversation, :messages)
        |> Map.put(:provider, provider)
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

  @spec get_conversations() :: {:ok, [Conversation.t()]} | {:error, Ecto.Changeset.t()}
  def get_conversations() do
    Repo.all(Conversation)
  end

  @spec get_conversation(String.t()) :: {:ok, Conversation.t()} | {:error, :not_found}
  def get_conversation(conversation_id) do
    Repo.get(preload(Conversation, messages: [:attachments, :provider]), conversation_id)
    |> case do
      nil -> {:error, :not_found}
      conversation -> {:ok, conversation}
    end
  end

  @spec send_message_to_provider(Message.t()) ::
          {:ok, Message.t()} | {:error, Ecto.Changeset.t()} | {:error, String.t()}
  def send_message_to_provider(message) do
    with {:ok, provider_message_id} <- ProviderContext.send_message(message) do
      update_provider_message_id(message, provider_message_id)
    end
  end

  @spec update_provider_message_id(Message.t(), String.t()) ::
          {:ok, Message.t()} | {:error, Ecto.Changeset.t()}
  defp update_provider_message_id(message, provider_message_id) do
    message
    |> Message.changeset(%{"provider_message_id" => provider_message_id})
    |> Repo.update()
  end

  @spec put_attachments(map()) :: map()
  defp put_attachments(params) do
    Map.update(params, "attachments", [], fn attachments ->
      if attachments do
        Enum.map(attachments, fn url -> %{"url" => url} end)
      else
        []
      end
    end)
  end

  defp get_provider(%{} = params) do
    with {:ok, type} <- get_type(params) do
      {:ok, Repo.one(from p in Provider, where: p.type == ^type and p.active)}
    end
  end

  @spec get_type(map()) :: {:ok, atom()} | {:error, :invalid_type}
  defp get_type(%{"type" => "sms"}), do: {:ok, :sms}
  defp get_type(%{"type" => "mms"}), do: {:ok, :mms}
  defp get_type(%{"type" => _}), do: {:error, :invalid_type}
  defp get_type(%{}), do: {:ok, :email}
end
