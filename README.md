# AshScratch

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ash_scratch` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ash_scratch, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/ash_scratch>.

``` elixir
➜  ash_scratch git:(main) ✗ iex -S mix
Compiling 1 file (.ex)
Erlang/OTP 26 [erts-14.2.2] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:1] [jit:ns]

Interactive Elixir (1.16.1) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> AshScratch.test
--> input api data: %{"project" => %{name: "AshExmp", desc: ""}, "resources" => [%{"actions" => [%{"implement" => "defaults", "name" => "read"}, %{"implement" => "create", "name" => "create"}], "attributes" => [%{"type" => "uuid_primary_key", "value" => "id"}, %{"field_type" => "string", "name" => "subject", "type" => "attribute"}], "domain" => "Helpdesk.Support", "module" => "Helpdesk.Support.Ticket", "name" => "Helpdesk.Support.Ticket"}]}
Converted to: defmodule Helpdesk.Support.Ticket do
  use Ash.Resource, domain: Helpdesk.Support

  actions do
    defaults([:read])
    create(:create)
  end

  attributes do
    uuid_primary_key(:id)
    attribute(:subject, :string)
  end
end
Originale module: defmodule Helpdesk.Support.Ticket do
  use Ash.Resource, domain: Helpdesk.Support

  actions do
    defaults([:read])
    create(:create)
  end

  attributes do
    uuid_primary_key(:id)
    attribute(:subject, :string)
  end
end

converted to scheme: %{"project" => %{name: "AshExmp", desc: ""}, "resources" => [%{"actions" => [%{"implement" => "defaults", "name" => "read"}, %{"implement" => "create", "name" => "create"}], "attributes" => [%{"type" => "uuid_primary_key", "value" => "id"}, %{"field_type" => "string", "name" => "subject", "type" => "attribute"}], "domain" => "Helpdesk.Support", "module" => "Helpdesk.Support.Ticket", "name" => "Helpdesk.Support.Ticket"}]}
true
iex(2)>
```
