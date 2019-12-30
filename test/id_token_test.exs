defmodule IDTokenTest do
  use ExUnit.Case
  import Mock

  describe "verify/2" do
    setup do
      IDToken.CertificateStore.erase(IDToken.Firebase)
      :ok
    end

    test "returns ok tuple" do
      token = Fixtures.GoogleCerts.token()
      response = Fixtures.GoogleCerts.response()

      Mock.with_mock Mojito, request: fn _, _ -> {:ok, response} end do
        assert {:ok, payload} = IDToken.verify(token, module: IDToken.Firebase)
        assert payload |> is_map()
      end
    end

    test "returns error tuple on failure" do
      token = Fixtures.GoogleCerts.token()

      Mock.with_mock Mojito, request: fn _, _ -> {:error, :something_went_wrong} end do
        assert {:error, :something_went_wrong} == IDToken.verify(token, module: IDToken.Firebase)
      end
    end

    test "returns error instead of raise even if token is badly invalid" do
      assert {:error, _} = IDToken.verify("", module: IDToken.Firebase)
      assert {:error, _} = IDToken.verify("a.b.c", module: IDToken.Firebase)
    end
  end
end
