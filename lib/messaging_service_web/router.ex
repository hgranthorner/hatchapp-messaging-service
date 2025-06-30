defmodule MessagingServiceWeb.Router do
  use MessagingServiceWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MessagingServiceWeb do
    pipe_through :api
  end
end
