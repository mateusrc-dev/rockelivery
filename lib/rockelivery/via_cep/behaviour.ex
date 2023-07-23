defmodule Rockelivery.ViaCep.Behaviour do
  alias Rockelivery.Error

  # we let's defined a type
  @typep client_result :: {:ok, map()} | {:error, Error.t()}

  # we let's defined the signature of client
  @callback get_cep_info(String.t()) :: client_result
end
