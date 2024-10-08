defmodule AshScratchTest do
  use ExUnit.Case
  doctest AshScratch

  test "greets the world" do
    assert AshScratch.hello() == :world
  end
end
