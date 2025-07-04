defmodule MessagingService.Repo.Migrations.CreateProviders do
  use Ecto.Migration

  def change do
    create table(:providers) do
      add :name, :text, null: false
      add :type, :message_type, null: false
      add :active, :boolean, default: true, null: false

      timestamps(type: :utc_datetime)
    end

    alter table(:messages) do
      remove :provider
      add :provider_id, references(:providers, on_delete: :delete_all)
    end

    create index(:messages, [:provider_id])
  end
end
