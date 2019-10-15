defmodule IDToken do
  @moduledoc """
  Entry point module for using this package.

  `verify/2` verifies JWT and returns claims.

      iex> IDToken.verify(token, module: IDToken.Firebase)
      {:ok, %{"aud" => "...", ... }}

  Callback module have to behave as `IDToken.Callback`.
  """

  @type opts :: [
          module: module()
        ]

  @spec verify(token :: String.t(), opts :: opts()) :: {:ok, map()} | {:error, term()}
  def verify(token, module: module) do
    [headers = %{"alg" => alg}, _payload] = decode_jwt(token)

    case fetch_cert(module) do
      {:ok, cert} ->
        key = module.verification_key(cert, headers)
        signer = Joken.Signer.create(alg, %{"pem" => key})
        Joken.verify(token, signer)

      error = {:error, _} ->
        error
    end
  end

  defp decode_jwt(token) do
    String.split(token, ".")
    |> Enum.take(2)
    |> Enum.map(&Base.decode64!(&1, padding: false))
    |> Enum.map(&Jason.decode!(&1))
  end

  defp fetch_cert(module) do
    case IDToken.CertificateStore.get(module) do
      nil -> fetch_then_store_cert(module)
      cert -> {:ok, cert}
    end
  end

  defp fetch_then_store_cert(module) do
    with {:ok, cert} <- module.fetch_certificates() do
      IDToken.CertificateStore.put(module, cert)
      {:ok, cert}
    end
  end
end
