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
    with {:ok, headers = %{"alg" => alg}} <- Joken.peek_header(token),
         {:ok, cert} <- fetch_cert(module) do
      key = module.verification_key(cert, headers)
      signer = Joken.Signer.create(alg, %{"pem" => key})
      Joken.verify(token, signer)
    else
      :error -> {:error, "invalid token #{token}"}
      error = {:error, _} -> error
    end
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
