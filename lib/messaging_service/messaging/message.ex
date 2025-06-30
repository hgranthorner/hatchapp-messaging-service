defmodule MessagingService.Messaging.Message do
  use TypedEctoSchema
  import Ecto.Changeset

  # NOTE(grant): We should probably add a "status" field to keep track
  # of whether the message has been sent, delivered, read, etc.
  typed_schema "messages" do
    field :type, Ecto.Enum, values: [:sms, :mms, :email]
    field :body, :string
    # These should maybe be foreign keys to addresses
    field :to, :string
    field :from, :string

    # In a real application this would be a foreign key to a Provider's table, where we may store additional metadata
    field :provider, :string

    # This works for now, but we may want to store additional information about the attachments in the future.
    # For example, we may want to save the url to the attachment, the attachment's size, etc.
    # In that case, we should change this to be a one-to-many relationship with a separate attachments table.
    field :attachments, {:array, :string}
    field :provider_message_id, :string

    # NIT: should probably be `:provider_timestamp`
    field :timestamp, :utc_datetime

    belongs_to :conversation, MessagingService.Messaging.Conversation

    timestamps(type: :utc_datetime, updated_at: false)
  end

  @doc """
  Create a changeset for a new text message, either SMS or MMS.
  """
  def text_changeset(%__MODULE__{} = message, %{} = attrs) do
    attrs =
      attrs
      |> Map.put_new("provider", "messaging_provider")
      |> Map.put_new("provider_message_id", Map.get(attrs, "messaging_provider_id"))

    changeset(message, attrs)
  end

  @doc """
  Create a changeset for a new email.
  """
  def email_changeset(%__MODULE__{} = message, %{} = attrs) do
    attrs =
      attrs
      |> Map.put_new("provider", "xillio")
      |> Map.put_new("provider_message_id", Map.get(attrs, "xillio_id"))
      |> Map.put_new("type", "email")

    changeset(message, attrs)
  end

  defp changeset(message, attrs) do
    message
    |> cast(attrs, [
      :from,
      :to,
      :type,
      :body,
      :attachments,
      :provider,
      :provider_message_id,
      :timestamp,
      :conversation_id
    ])
    |> validate_required([:from, :to, :type, :body, :provider, :timestamp])
  end
end
