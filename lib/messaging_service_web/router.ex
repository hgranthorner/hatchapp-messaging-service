defmodule MessagingServiceWeb.Router do
  use MessagingServiceWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/messages", MessagingServiceWeb do
    pipe_through :api
    post "/sms", SmsController, :outgoing
    post "/email", EmailController, :outgoing
  end

  scope "/api/webhooks", MessagingServiceWeb do
    pipe_through :api
    post "/sms", SmsController, :incoming
    post "/email", EmailController, :incoming
  end

  scope "/api/conversations", MessagingServiceWeb do
    pipe_through :api
    get "/", ConversationController, :index
    get "/:id/messages", ConversationController, :show
  end
end
