defmodule RockeliveryWeb.UsersViewTest do
  use RockeliveryWeb.ConnCase, async: true
  alias RockeliveryWeb.UsersView
  import Phoenix.View
  import Rockelivery.Factory

  test "renders create.json" do
    user = build(:user)

    response = render(UsersView, "create.json", user: user)

    assert %{
             message: "User created!",
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
               inserted_at: nil,
               updated_at: nil
             }
           } = response
  end
end
