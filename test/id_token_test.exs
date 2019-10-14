defmodule IDTokenTest do
  use ExUnit.Case
  import Mock

  describe "verify/2" do
    test "returns ok tuple" do
      token = Fixtures.GoogleCerts.token()
      response = Fixtures.GoogleCerts.response()

      Mock.with_mock Mojito, request: fn _, _ -> {:ok, response} end do
        {:ok, payload} = IDToken.verify(token, module: IDToken.Firebase)
      end
    end
  end
end
