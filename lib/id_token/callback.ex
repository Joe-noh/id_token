defmodule IDToken.Callback do
  @doc """
  Callback function for fetching public key certificates.

  Must return a {:ok, `%IDToken.Certificate{}`} tuple and this will be cached
  for later use.
  """
  @callback fetch_certificates() :: IDToken.Certificate.t()

  @doc """
  Callback function to get verification key from certificates which is fetched
  with `fetch_certificates/0`

  The JWT headers are given as the second argument `headers`.
  """
  @callback verification_key(certificate :: IDToken.Certificate.t(), headers :: map()) :: String.t()
end
