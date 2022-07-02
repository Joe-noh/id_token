defmodule IDToken.Firebase do
  @moduledoc """
  Predefined callback module for firebase users.
  """

  @behaviour IDToken.Callback

  @impl true
  def fetch_certificates do
    with url = "https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com",
         {:ok, %Finch.Response{body: body, headers: headers}} <- get_request(url),
         {:ok, keys} <- Jason.decode(body),
         {:ok, expires_at} <- expires_at(headers) do
      {:ok, %IDToken.Certificate{body: keys, expires_at: expires_at}}
    else
      tuple = {:error, _} -> tuple
      reason -> {:error, reason}
    end
  end

  @impl true
  def verification_key(%IDToken.Certificate{body: body}, %{"kid" => kid}) do
    Map.get(body, kid)
  end

  defp get_request(url) do
    Finch.build(:get, url) |> Finch.request(IdToken.Finch)
  end

  defp expires_at([{"cache-control", cache_control} | _]) do
    [_entire_matched, max_age] = Regex.run(~r[max-age=(\d+)], cache_control)
    expire = DateTime.utc_now() |> DateTime.add(String.to_integer(max_age), :second)

    {:ok, expire}
  end

  defp expires_at([]) do
    {:error, :cache_control_not_found}
  end

  defp expires_at([_ | tail]) do
    expires_at(tail)
  end
end
