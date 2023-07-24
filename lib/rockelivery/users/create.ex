defmodule Rockelivery.Users.Create do
  alias Rockelivery.{Error, User, Repo}

  def call(params) do
    cep = Map.get(params, "cep")
    changeset = User.changeset(params)

    with {:ok, %User{}} <- User.build(changeset),
         {:ok, _cep_info} <- client().get_cep_info(cep),
         {:ok, %User{}} = user <- Repo.insert(changeset) do
      user
      # Repo.insert(user)
      # Repo.insert can also receive a struct - the user is a struct - if Repo.insert receives a struct it will understand that the user has been validated
    else
      {:error, %Error{}} = error ->
        error

      {:error, result} ->
        {:error, Error.build(:bad_request, result)}

        # if this error is not handled here it will be returned to the fallback module
    end
  end

  defp client do
    :rockelivery
    |> Application.fetch_env!(__MODULE__)
    |> Keyword.get(:via_cep_adapter)
  end
end
