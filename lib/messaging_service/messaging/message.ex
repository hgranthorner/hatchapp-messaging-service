defmodule MessagingService.Messaging.Message do
  use TypedEctoSchema
  import Ecto.Changeset

  typed_schema "messages" do
    field :type, Ecto.Enum, values: [:sms, :mms, :email]
    field :body, :string
    field :to, :string
    field :from, :string
    field :provider, :string
    field :attachments, {:array, :string}
    field :provider_message_id, :string
    field :timestamp, :utc_datetime

    timestamps(type: :utc_datetime, updated_at: false)
  end

  def text_changeset(%__MODULE__{} = message, %{} = attrs) do
    attrs =
      attrs
      |> Map.put_new("provider", "messaging_provider")
      |> Map.put_new("provider_message_id", Map.get(attrs, "messaging_provider_id"))

    changeset(message, attrs)
  end

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
      :timestamp
    ])
    |> validate_required([:from, :to, :type, :body, :provider, :timestamp])
  end
end
