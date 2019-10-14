defmodule IDToken.Certificate do
  @type t :: %__MODULE__{}

  defstruct [:body, :expires_at]

  @spec new(body :: any(), expires_at :: DateTime.t()) :: t()
  def new(body, expires_at) do
    %__MODULE__{body: body, expires_at: expires_at}
  end
end
