defmodule MessagingService.Messaging.Attachment do
  use TypedEctoSchema
  import Ecto.Changeset

  typed_schema "attachments" do
    field :url, :string
    belongs_to :message, MessagingService.Messaging.Message

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(attachment, attrs) do
    attachment
    |> cast(attrs, [:url])
    |> validate_required([:url])
  end
end
