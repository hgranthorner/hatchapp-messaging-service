defmodule MessagingService.Repo.Migrations.CreateConversations do
  use Ecto.Migration

  def change do
    create table(:conversations) do
      add :user_1, :text, null: false
      add :user_2, :text, null: false

      timestamps(type: :utc_datetime)
    end

    alter table(:messages) do
      add :conversation_id, references(:conversations, on_delete: :delete_all), null: false
    end
  end
end
