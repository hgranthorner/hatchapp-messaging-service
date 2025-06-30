defmodule MessagingService.Repo.Migrations.CreateAttachments do
  use Ecto.Migration

  def change do
    create table(:attachments) do
      add :url, :text, null: false
      add :message_id, references(:messages, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    alter table(:messages) do
      remove :attachments
    end

    create index(:attachments, [:message_id])
  end
end
