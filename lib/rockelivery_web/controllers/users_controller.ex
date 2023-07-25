defmodule RockeliveryWeb.UsersController do
  use RockeliveryWeb, :controller
  alias Rockelivery.User
  alias RockeliveryWeb.FallbackController
  alias RockeliveryWeb.Auth.Guardian

  action_fallback FallbackController

  def create(conn, params) do
    # function 'encode_and_sign' already exist by default in guardian - this function do the encode of user and create the token jwt
    with {:ok, %User{} = user} <- Rockelivery.create_user(params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render("create.json", token: token, user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %User{}} <- Rockelivery.delete_user(id) do
      conn
      |> put_status(:no_content)
      |> text("")
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, %User{} = user} <- Rockelivery.get_user_by_id(id) do
      conn
      |> put_status(:ok)
      |> render("user.json", user: user)
    end
  end

  def update(conn, params) do
    with {:ok, %User{} = user} <- Rockelivery.update_user(params) do
      conn
      |> put_status(:ok)
      |> render("user.json", user: user)
    end
  end
end

# we let's don't use 'put_view' because the name of 'user_controller' is equal the name of file 'user_view'
