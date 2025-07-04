defmodule MessagingService.Messaging.Provider do
  use Ecto.Schema
  import Ecto.Changeset

  schema "providers" do
    field :active, :boolean, default: false
    field :name, :string
    field :type, Ecto.Enum, values: [:sms, :mms, :email]

    has_many :messages, MessagingService.Messaging.Message
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(provider, attrs) do
    provider
    |> cast(attrs, [:name, :type, :active])
    |> validate_required([:name, :type, :active])
  end
end
