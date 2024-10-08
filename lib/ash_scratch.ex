defmodule AshScratch do
  @moduledoc """
  Documentation for `AshScratch`.
  """
  @original """
  defmodule Helpdesk.Support.Ticket do
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
  """

  @raw %{
  "project" => %{name: "AshExmp", desc: ""},
  "resources" => [
    %{
      "actions" => [
        %{"implement" => "defaults", "name" => "read"},
        %{"implement" => "create", "name" => "create"}
      ],
      "attributes" => [
        %{"type" => "uuid_primary_key", "value" => "id"},
        %{"field_type" => "string", "name" => "subject", "type" => "attribute"}
      ],
      "domain" => "Helpdesk.Support",
      "module" => "Helpdesk.Support.Ticket",
      "name" => "Helpdesk.Support.Ticket"
    }
  ]
}

  def test do
    resources_schema =
      Enum.map(convert(), fn resource ->
        IO.puts "Converted to: #{Code.format_string!(resource)}"
        IO.puts "Originale module: #{@original}"
        Code.format_string!(resource) == @original
        {:ok, ast} = Spitfire.parse(resource)

        {uses, actions, attributes, module} = extract(ast)

        [{:use, _, [{:__aliases__, _, [:Ash, :Resource]}, [domain: {:__aliases__, _, domain}]]}] = uses

        [{:attributes, _, [[do: {:__block__, [], list_attributes}]]}] = attributes

        [{:actions, _meta, [[do: {:__block__, [], list_actions}]]}] = actions

        %{
          "name" => module,
          "module" => module,
          "domain" => Enum.join(domain, "."),
          "actions" =>
            Enum.map(list_actions, fn
              {:defaults, _, [[v]]} -> %{"name" => "#{v}", "implement" => "defaults"}
              {t, _, [v]} -> %{"name" => "#{v}", "implement" => "#{t}"}
            end),
          "attributes" =>
            Enum.map(list_attributes, fn
              {k, _, [name, type]} ->
                %{"type" => "#{k}", "name" => "#{name}", "field_type" => "#{type}"}

              {k, _, [v]} ->
                %{"type" => "#{k}", "value" => "#{v}"}
            end)
        }
      end)

    res = %{
      "project" => %{name: "AshExmp", desc: ""},
      "resources" => resources_schema
    }
    IO.puts "converted to scheme: #{inspect(res)}"
    res == @raw
  end

  def convert do
    IO.puts "--> input api data: #{inspect(@raw)}"
    %{"resources" => resources} = @raw

    Enum.map(resources, fn %{
                             "module" => module,
                             "domain" => domain,
                             "actions" => actions,
                             "attributes" => attributes
                           } ->
      default_actions =
        Enum.filter(actions, &(Map.get(&1, "implement") == "defaults"))
        |> Enum.map(&String.to_atom(Map.get(&1, "name")))

      custom_actions =
        Enum.filter(actions, &(not (Map.get(&1, "implement") == "defaults")))
        |> Enum.map(&Map.get(&1, "name"))

      ash_attributes = Enum.map(attributes, &build_attributes/1) |> Enum.join("\n")

      """
      defmodule #{module} do
        use Ash.Resource, domain: #{domain}

         actions do
           defaults #{inspect(default_actions)}
      #{Enum.map(custom_actions, fn c -> "#{c} :#{c}" end)}
         end

         attributes do
      #{ash_attributes}
         end
      end
      """
    end)
  end

  defp build_attributes(%{"type" => "uuid_primary_key", "value" => column}) do
    "uuid_primary_key :#{column}"
  end

  defp build_attributes(%{"type" => "attribute", "name" => column, "field_type" => type}) do
    "attribute :#{column}, :#{type}"
  end

  def extract(ast) do
    {_new_ast, result} =
      Macro.prewalk(ast, {[], [], [], ""}, fn
        {:use, _, _} = node, {uses, actions, attributes, module} ->
          {node, {[node | uses], actions, attributes, module}}

        {:actions, _, _} = node, {uses, actions, attributes, module} ->
          {node, {uses, [node | actions], attributes, module}}

        {:attributes, _, _} = node, {uses, actions, attributes, module} ->
          {node, {uses, actions, [node | attributes], module}}

        {:defmodule, _, [{:__aliases__, _, names} | _]} = node,
        {uses, actions, attributes, _module} ->
          {node, {uses, actions, attributes, Enum.join(names, ".")}}

        other, acc ->
          {other, acc}
      end)

    result
  end
end
