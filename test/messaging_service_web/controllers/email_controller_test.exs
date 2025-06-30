defmodule MessagingServiceWeb.EmailControllerTest do
  alias Ecto.UUID
  use MessagingServiceWeb.ConnCase, async: true
  import MessagingService.MessagingFixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "incoming message" do
    test "succeeds", %{conn: conn} do
      conn = post(conn, ~p"/api/messages/email", email_attrs())
      assert response(conn, 200)
    end

    test "creates a new conversation", %{conn: conn} do
      attrs = email_attrs() |> Map.put("from", UUID.generate())
      conn = post(conn, ~p"/api/messages/email", attrs)
      assert response(conn, 200)
      conn = get(conn, ~p"/api/conversations")
      body = json_response(conn, 200)

      assert Enum.find(body["data"], fn conv ->
               Enum.find(conv["participants"], nil, &(&1 == attrs["from"]))
             end)

      conv_id = body["data"] |> List.first() |> Map.get("id")
      conn = get(conn, ~p"/api/conversations/#{conv_id}/messages")
      body = json_response(conn, 200)
      data = body["data"]

      assert data["messages"]
             |> Enum.find(fn m ->
               m["from"] == attrs["from"] and m["to"] == attrs["to"]
             end)
    end
  end

  test "outgoing message", %{conn: conn} do
    conn = post(conn, ~p"/api/webhooks/email", email_attrs())
    assert response(conn, 200)
  end
end
