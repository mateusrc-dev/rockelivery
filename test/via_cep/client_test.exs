defmodule Rockelivery.ViaCep.ClientTest do
  use ExUnit.Case, async: true
  alias Rockelivery.ViaCep.Client
  alias Plug.Conn
  alias Rockelivery.Error

  describe "get_cep_info/1" do
    setup do
      bypass = Bypass.open()

      # to make call to local server which bypass will activate

      {:ok, bypass: bypass}
    end

    test "when there is a valid cep, returns the cep info", %{bypass: bypass} do
      cep = "01001000"
      url = endpoint_url(bypass.port)

      body = ~s({
        "cep": "01001-000",
        "logradouro": "Praça da Sé",
        "complemento": "lado ímpar",
        "bairro": "Sé",
        "localidade": "São Paulo",
        "uf": "SP",
        "ibge": "3550308",
        "gia": "1004",
        "ddd": "11",
        "siafi": "7107"
      })

      # requests in Bypass occur in localhost - over it, we will have that use a url different
      # this expect bypass is a mock
      Bypass.expect(bypass, "GET", "#{cep}/json/", fn conn ->
        conn
        |> Conn.put_resp_header("content-type", "application/json")
        |> Conn.resp(200, body)
      end)

      response = Client.get_cep_info(url, cep)

      expected_response =
        {:ok,
         %{
           "bairro" => "Sé",
           "cep" => "01001-000",
           "complemento" => "lado ímpar",
           "ddd" => "11",
           "gia" => "1004",
           "ibge" => "3550308",
           "localidade" => "São Paulo",
           "logradouro" => "Praça da Sé",
           "siafi" => "7107",
           "uf" => "SP"
         }}

      assert response == expected_response
    end

    test "when the cep is invalid, returns an error", %{bypass: bypass} do
      cep = "123"
      url = endpoint_url(bypass.port)

      # requests in Bypass occur in localhost - over it, we will have that use a url different
      # this expect bypass is a mock
      Bypass.expect(bypass, "GET", "#{cep}/json/", fn conn ->
        Conn.resp(conn, 400, "")
      end)

      response = Client.get_cep_info(url, cep)

      expected_response =
        {:error,
         %Error{
           status: :bad_request,
           result: "CEP is invalid!"
         }}

      assert response == expected_response
    end

    test "when the cep was not found, returns an error", %{bypass: bypass} do
      cep = "00000000"

      body = ~s({"erro": true})

      url = endpoint_url(bypass.port)

      # requests in Bypass occur in localhost - over it, we will have that use a url different
      # this expect bypass is a mock
      Bypass.expect(bypass, "GET", "#{cep}/json/", fn conn ->
        conn
        |> Conn.put_resp_header("content-type", "application/json")
        |> Conn.resp(200, body)
      end)

      response = Client.get_cep_info(url, cep)

      expected_response =
        {:error,
         %Error{
           status: :not_found,
           result: "CEP not found!"
         }}

      assert response == expected_response
    end

    test "when there is a generic error, returns an error", %{bypass: bypass} do
      cep = "00000000"

      url = endpoint_url(bypass.port)

      # requests in Bypass occur in localhost - over it, we will have that use a url different
      # down will close server just in this test
      Bypass.down(bypass)

      response = Client.get_cep_info(url, cep)

      expected_response =
        {:error,
         %Error{
           status: :bad_request,
           result: :econnrefused
         }}

      assert response == expected_response
    end

    defp endpoint_url(port) do
      "http://localhost:#{port}/"
    end
  end
end
