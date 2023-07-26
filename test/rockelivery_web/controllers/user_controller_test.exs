defmodule RockeliveryWeb.UsersControllerTest do
  use RockeliveryWeb.ConnCase, async: true
  alias Rockelivery.User
  alias Rockelivery.ViaCep.BehaviourMock
  alias RockeliveryWeb.Auth.Guardian
  import Rockelivery.Factory
  import Mox

  describe "create/2" do
    test "when all params are valid, creates the user", %{conn: conn} do
      params = %{
        "age" => 27,
        "address" => "Rua das bananeiras, 15",
        "cep" => "12345678",
        "cpf" => "12345678901",
        "email" => "mateus@bananas.com",
        "password" => "123456",
        "name" => "Mateus"
      }

      expect(BehaviourMock, :get_cep_info, fn _cep ->
        {:ok, build(:cep_info)}
      end)

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:created)

      assert %{
               "message" => "User created!",
               "user" => %{
                 "address" => "Rua das bananeiras, 15",
                 "age" => 27,
                 "cpf" => "12345678901",
                 "email" => "mateus@bananas.com",
                 "id" => _id
               }
             } = response
    end

    test "when there is some error, returns the error", %{conn: conn} do
      params = %{
        "password" => "123456",
        "name" => "Mateus"
      }

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:bad_request)

      expected_response = %{
        "message" => %{
          "address" => ["can't be blank"],
          "age" => ["can't be blank"],
          "cep" => ["can't be blank"],
          "cpf" => ["can't be blank"],
          "email" => ["can't be blank"]
        }
      }

      assert expected_response = response
    end
  end

  describe "delete/2" do
    setup %{conn: conn} do
      user = insert(:user)
      {:ok, token, _claims} = Guardian.encode_and_sign(user)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn}
    end

    test "when there is a user with the given id, deletes the user", %{conn: conn} do
      id = "00c0fb92-6198-4fc6-b9e7-1e581ec7ca75"

      response =
        conn
        |> delete(Routes.users_path(conn, :delete, id))
        |> response(:no_content)

      # no-content

      assert response == ""
    end
  end
end
