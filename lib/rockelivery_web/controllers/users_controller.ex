defmodule RockeliveryWeb.UsersController do
  use RockeliveryWeb, :controller
  alias Rockelivery.User
  alias RockeliveryWeb.FallbackController

  action_fallback FallbackController

  def create(conn, params) do
    with {:ok, %User{} = user} <- Rockelivery.create_user(params) do
      conn
      |> put_status(:created)
      |> render("create.json", user: user)
    end
  end
end

# we let's don't use 'put_view' because the name of 'user_controller' is equal the name of file 'user_view'
