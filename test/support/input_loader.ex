defmodule Aoc.InputLoader do
  @moduledoc """
  Loads challenge inputs
  """

  @doc """
  Loads the given file as a string
  """
  def input(year, day) do
    day = day |> Integer.to_string() |> String.pad_leading(2, "0")

    "priv/inputs/year_#{year}/day_#{day}.txt"
    |> Path.expand()
    |> Path.absname()
    |> File.read!()
    |> String.trim()
  end
end
