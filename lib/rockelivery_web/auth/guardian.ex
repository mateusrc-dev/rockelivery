defmodule RockeliveryWeb.Auth.Guardian do
  use Guardian, otp_app: :rockelivery
  alias Rockelivery.User
  alias Rockelivery.Users.Get, as: UserGet

  # function that will defined the 'sub' - 'sub' will be defined with id of user
  def subject_for_token(%User{id: id}, _claims) do
    {:ok, id}
  end

  def resource_from_claims(%{"sub" => id}) do
    id
    |> UserGet.by_id()
  end
end
