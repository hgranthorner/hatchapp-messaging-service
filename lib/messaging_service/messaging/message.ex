defmodule MessagingService.Messaging.Message do
  use TypedEctoSchema
  import Ecto.Changeset

  schema "messages" do
    field :type, Ecto.Enum, values: [:sms, :mms, :email]
    field :body, :string
    field :to, :string
    field :from, :string
    field :provider, :string
    field :attachments, :map
    field :provider_message_id, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:from, :to, :type, :body, :attachments, :provider, :provider_message_id])
    |> validate_required([:from, :to, :type, :body, :provider])
  end
end
