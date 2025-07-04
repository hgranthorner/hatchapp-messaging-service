defmodule MessagingServiceWeb.SmsController do
  use MessagingServiceWeb, :controller
  alias MessagingService.Messaging

  action_fallback MessagingServiceWeb.FallbackController

  def incoming(conn, params) do
    # TODO: forward message to user
    # TODO: validate incoming message comes from provider
    # validate_incoming_message(conn, params)

    case validate_json(params) do
      # NOTE(grant): This may be overkill
      {:ok, _changeset} ->
        Messaging.insert_text(params)
        send_resp(conn, 200, "OK")

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def outgoing(conn, params) do
    # TODO: forward message to provider
    case validate_json(params) do
      {:ok, changeset} ->
        Messaging.insert_text(params)
        send_resp(conn, 200, "OK")

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  defp validate_json(params) do
    types = %{to: :string, from: :string, type: :string}

    changeset =
      {%{}, types}
      |> Ecto.Changeset.cast(params, Map.keys(types))
      |> Ecto.Changeset.validate_required([:to, :from, :type])

    if changeset.valid? do
      {:ok, changeset}
    else
      {:error, changeset}
    end
  end

  # def provider_send_message(message) do
  #   case [200, 429, 500] do
  #     200 -> :ok
  #     429 -> retry()
  #     500 -> :error
  #   end
  # end
end
