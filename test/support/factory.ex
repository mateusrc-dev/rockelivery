defmodule Rockelivery.Factory do
  use ExMachina.Ecto, repo: Rockelivery.Repo
  alias Rockelivery.User

  def user_params_factory do
    %{
      age: 27,
      address: "Rua das bananeiras, 15",
      cep: "12345678",
      cpf: "12345678901",
      email: "mateus@bananas.com",
      password: "123456",
      name: "Mateus"
    }
  end

  def user_factory do
    %User{
      age: 27,
      address: "Rua das bananeiras, 15",
      cep: "12345678",
      cpf: "12345678901",
      email: "mateus@bananas.com",
      password: "123456",
      name: "Mateus",
      id: "00c0fb92-6198-4fc6-b9e7-1e581ec7ca75"
    }
  end
end
