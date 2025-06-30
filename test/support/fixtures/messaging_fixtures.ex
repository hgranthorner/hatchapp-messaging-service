defmodule MessagingService.MessagingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MessagingService.Messaging` context.
  """

  @doc """
  Generate a message.
  """
  def message_fixture(attrs \\ %{}) do
    {:ok, message} =
      attrs
      |> Enum.into(%{
        attachments: %{},
        body: "some body",
        from: "some from",
        provider: "some provider",
        provider_message_id: "some provider_message_id",
        to: "some to",
        type: :sms
      })
      |> MessagingService.Messaging.create_message()

    message
  end
end
