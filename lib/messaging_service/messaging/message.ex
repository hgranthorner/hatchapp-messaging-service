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

    # This works for now, but we may want to store additional information about the attachments in the future.
    # For example, we may want to save the url to the attachment, the attachment's size, etc.
    # In that case, we should change this to be a one-to-many relationship with a separate attachments table.
    field :provider_message_id, :string

    # NIT: should probably be `:provider_timestamp`
    field :timestamp, :utc_datetime

    has_many :attachments, MessagingService.Messaging.Attachment
    belongs_to :provider, MessagingService.Messaging.Provider
    belongs_to :conversation, MessagingService.Messaging.Conversation

    timestamps(type: :utc_datetime, updated_at: false)
  end

  @doc """
  Create a changeset for a new text message, either SMS or MMS.
  """
  def text_changeset(%__MODULE__{} = message, %{} = attrs) do
    attrs =
      attrs
      |> Map.put_new("provider_message_id", Map.get(attrs, "messaging_provider_id"))

    changeset(message, attrs)
  end

  @doc """
  Create a changeset for a new email.
  """
  def email_changeset(%__MODULE__{} = message, %{} = attrs) do
    attrs =
      attrs
      |> Map.put_new("provider_message_id", Map.get(attrs, "xillio_id"))

    changeset(message, attrs)
  end

  defp changeset(message, attrs) do
    message
    |> cast(attrs, [
      :from,
      :to,
      :type,
      :body,
      :provider_message_id,
      :timestamp,
      :conversation_id
    ])
    |> cast_assoc(:attachments, with: &MessagingService.Messaging.Attachment.changeset/2)
    |> validate_required([:from, :to, :type, :body, :provider, :timestamp])
  end
end
