defmodule MessagingService.Repo.Migrations.AddMessageTypeEnum do
  use Ecto.Migration

  def change do
    execute "CREATE TYPE message_type AS ENUM ('sms', 'mms', 'email');", "DROP TYPE message_type;"
  end
end
