defmodule RockeliveryWeb.UsersViewTest do
  use RockeliveryWeb.ConnCase, async: true
  alias RockeliveryWeb.UsersView
  import Phoenix.View
  import Rockelivery.Factory

  test "renders create.json" do
    user = build(:user)

    # this token don't will to spend in plugs, will just be render
    token = "xpto1234"
    response = render(UsersView, "create.json", token: token, user: user)

    assert %{
             message: "User created!",
             token: "xpto1234",
             user: %Rockelivery.User{
               id: "00c0fb92-6198-4fc6-b9e7-1e581ec7ca75",
               age: 27,
               address: "Rua das bananeiras, 15",
               cep: "12345678",
               cpf: "12345678901",
               email: "mateus@bananas.com",
               password: "123456",
               password_hash: nil,
               name: "Mateus",
               orders: _,
               inserted_at: nil,
               updated_at: nil
             }
           } = response
  end
end
