defmodule IdToken.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      {Finch, name: IdToken.Finch}
    ]

    opts = [strategy: :one_for_one, name: IdToken.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
