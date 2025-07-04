defmodule MessagingService.Provider do
  @moduledoc """
  This context provides functionality for sending messages through various providers.

  This is an extremely naive implementation of this context.

  The `send_message/1` function should send requests to a separate process that is responsible for managing the
  retry logic for a particular provider.

  Rough architecture:
  send_message -> SMS/MMS/EmailProvider -> separate processes to send messages
  """
  alias Ecto.UUID
  alias MessagingService.Messaging.Message

  # NOTE(grant): Arbitrary choice
  @max_timeout 16

  # NOTE(grant): In a real application, we would call out to other provider's SDKs or APIs here.
  @spec send_message(Message.t()) :: {:ok, String.t()} | {:error, String.t()}
  def send_message(%Message{type: :sms} = msg), do: dummy_send_message(msg)
  def send_message(%Message{type: :mms} = msg), do: dummy_send_message(msg)
  def send_message(%Message{type: :email} = msg), do: dummy_send_message(msg)

  # NOTE(grant): Simulating a call to a provider's API.
  defp dummy_send_message(msg, opts \\ []) do
    previous_retry_amount = Keyword.get(opts, :previous_retry_amount, 0)

    case send(msg) do
      {:"200", provider_id} ->
        {:ok, provider_id}

      {:"429"} ->
        timeout =
          if previous_retry_amount == 0,
            do: 2,
            else: Integer.pow(previous_retry_amount, 2)

        if timeout > @max_timeout do
          {:error, "Rate limit exceeded"}
        else
          Process.sleep(timeout)
          dummy_send_message(msg, previous_retry_amount: timeout)
        end

      {:"500", error: error} ->
        {:error, error}
    end
  end

  @spec send(Message.t()) ::
          {:"200", String.t()}
          | {:"429"}
          | {:"500", error: String.t()}
  defp send(_msg) do
    {:"200", UUID.generate()}
  end
end
