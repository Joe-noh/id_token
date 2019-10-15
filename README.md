## IDToken

### Installation

```elixir
def deps do
  [
    {:id_token, "~> 0.1"}
  ]
end
```

### Usage

```elixir
IDToken.verify(jwt, module: IDToken.Firebase)
#=> {:ok, payload}
```

More on docs: [https://hexdocs.pm/id_token](https://hexdocs.pm/id_token)

### Note

This needs OTP version 21.2 or higher due to using `:persistent_term`.
