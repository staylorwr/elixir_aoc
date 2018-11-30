defmodule AocTest do
  use ExUnit.Case
  doctest Aoc

  test "greets the world" do
    assert Aoc.hello() == :world
  end
end
