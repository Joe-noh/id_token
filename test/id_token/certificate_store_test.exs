defmodule IDToken.CertificateStoreTest do
  use ExUnit.Case, async: true

  alias IDToken.{CertificateStore, Certificate}

  setup do
    now = DateTime.utc_now()

    %{
      expired_cert: Certificate.new("secret", DateTime.add(now, -60, :second)),
      unexpired_cert: Certificate.new("secret", DateTime.add(now, 60, :second))
    }
  end

  test "put unexpired certificate then get it", %{test: key, unexpired_cert: cert} do
    assert :ok == CertificateStore.put(key, cert)
    assert cert == CertificateStore.get(key)
  end

  test "returns nil if expired", %{test: key, expired_cert: cert} do
    assert :ok == CertificateStore.put(key, cert)
    assert nil == CertificateStore.get(key)
  end

  test  "erase from store", %{test: key, unexpired_cert: cert} do
    assert :ok == CertificateStore.put(key, cert)

    CertificateStore.erase(key)

    assert nil == CertificateStore.get(key)
  end
end
