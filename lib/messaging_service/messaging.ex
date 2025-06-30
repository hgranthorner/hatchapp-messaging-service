defmodule MessagingService.Messaging do
  @moduledoc """
  The Messaging context.
  """

  import Ecto.Query, warn: false
  alias MessagingService.Repo

  alias MessagingService.Messaging.Message

  @spec insert_text(map()) :: {:ok, Message.t()} | {:error, Ecto.Changeset.t()}
  def insert_text(%{} = params) do
    %Message{}
    |> Message.text_changeset(params)
    |> Repo.insert()
  end

  @spec insert_email(map()) :: {:ok, Message.t()} | {:error, Ecto.Changeset.t()}
  def insert_email(%{} = params) do
    %Message{}
    |> Message.email_changeset(params)
    |> Repo.insert()
  end
end
