defmodule Rockelivery.Users.CreateTest do
  use Rockelivery.DataCase, async: true
  alias Rockelivery.{Error, User}
  alias Rockelivery.Users.Create
  alias Rockelivery.Error
  alias Rockelivery.ViaCep.BehaviourMock

  import Mox
  import Rockelivery.Factory

  describe "call/1" do
    test "when all params are valid, returns the user" do
      params = build(:user_params)

      # expect that a called for the ClientMock will be execute
      expect(BehaviourMock, :get_cep_info, fn _cep ->
        {:ok, build(:cep_info)}
      end)

      response = Create.call(params)

      assert {:ok, %User{id: _id, age: 27, email: "mateus@bananas.com"}} = response
    end

    test "when there are invalid params, returns an error" do
      params = build(:user_params, %{"password" => "123", "age" => 15})

      response = Create.call(params)

      expected_response = %{
        age: ["must be greater than or equal to 18"],
        password: ["should be at least 6 character(s)"]
      }

      assert {:error, %Error{status: :bad_request, result: changeset}} = response
      assert errors_on(changeset) == expected_response
    end
  end
end
