defmodule MessagingService.Messaging.Conversation do
  use TypedEctoSchema
  import Ecto.Changeset

  typed_schema "conversations" do
    field :user_1, :string
    field :user_2, :string

    has_many :messages, MessagingService.Messaging.Message

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(conversation, attrs) do
    conversation
    |> cast(attrs, [:user_1, :user_2])
    |> validate_required([:user_1, :user_2])
  end
end
