defmodule Rockelivery.UserTest do
  use Rockelivery.DataCase, async: true
  alias Rockelivery.User
  alias Ecto.Changeset

  describe "changeset/2" do
    test "when all params are valid, returns a valid changeset" do
      params = %{
        age: 27,
        address: "Rua das bananeiras, 15",
        cep: "12345678",
        cpf: "12345678901",
        email: "mateus@bananas.com",
        password: "123456",
        name: "Mateus"
      }

      response = User.changeset(params)

      assert %Changeset{changes: %{name: "Mateus"}, valid?: true} = response
    end

    test "when updating a changeset, returns invalid changeset with the given changes" do
      params = %{
        age: 27,
        address: "Rua das bananeiras, 15",
        cep: "12345678",
        cpf: "12345678901",
        email: "mateus@bananas.com",
        password: "123456",
        name: "Mateus"
      }

      update_params = %{name: "Bananinha", password: "123456"}

      response =
        params
        |> User.changeset()
        |> User.changeset(update_params)

      assert %Changeset{changes: %{name: "Bananinha"}, valid?: true} = response
    end

    test "when there are some error, returns an invalid changeset" do
      params = %{
        age: 15,
        address: "Rua das bananeiras, 15",
        cep: "12345678",
        cpf: "12345678901",
        email: "mateus@bananas.com",
        password: "123",
        name: "Mateus"
      }

      response = User.changeset(params)

      expected_response = %{
        age: ["must be greater than or equal to 18"],
        password: ["should be at least 6 character(s)"]
      }

      assert errors_on(response) == expected_response
    end
  end
end
