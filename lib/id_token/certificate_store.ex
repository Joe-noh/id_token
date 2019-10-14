defmodule IDToken.CertificateStore do
  alias IDToken.Certificate

  def put(key, cert = %Certificate{}) do
    :persistent_term.put({__MODULE__, key}, cert)
  end

  def get(key) do
    :persistent_term.get({__MODULE__, key}, nil) |> check_expired()
  end

  def get(key, missing_fn) do
    case get(key) do
      nil ->
        put(key, missing_fn.())
        get(key)

      something ->
        something
    end
  end

  defp check_expired(cert = %Certificate{expires_at: expires_at}) do
    DateTime.utc_now()
    |> DateTime.add(-30, :second)
    |> DateTime.compare(expires_at)
    |> case do
      :gt -> nil
      _eq_lt -> cert
    end
  end

  defp check_expired(nil) do
    nil
  end
end
