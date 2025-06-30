defmodule MessagingService.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :from, :text, null: false
      add :to, :text, null: false
      add :type, :message_type, null: false
      add :body, :text, null: false
      add :attachments, :map
      add :provider, :text, null: false
      add :provider_message_id, :text

      timestamps(type: :utc_datetime, updated_at: false)
    end
  end
end
