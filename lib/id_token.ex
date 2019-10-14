defmodule IDToken do
  @moduledoc """
  Entry point module for using this package.
  """

  @type opts :: [
    module: module()
  ]

  @spec verify(token :: String.t(), opts :: opts()) :: {:ok, map()} | {:error, term()}
  def verify(token, module: module) do
    [headers = %{"alg" => alg}, _payload] = decode_jwt(token)

    key =
      module
      |> get_cert_from_store()
      |> module.verification_key(headers)

    signer = Joken.Signer.create(alg, %{"pem" => key})
    Joken.verify(token, signer)
  end

  defp get_cert_from_store(module) do
    IDToken.CertificateStore.get(module, fn ->
      module.fetch_certificates()
    end)
  end

  defp decode_jwt(token) do
    String.split(token, ".")
    |> Enum.take(2)
    |> Enum.map(& Base.decode64!(&1, padding: false))
    |> Enum.map(& Jason.decode!(&1))
  end
end
