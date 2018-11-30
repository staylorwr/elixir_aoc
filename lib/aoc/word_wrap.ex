defmodule Aoc.WordWrap do
  def paragraph(string, max_line_length) do
    [word | rest] = String.split(string, ~r/\s+/, trim: true)

    lines_assemble(rest, max_line_length, String.length(word), word, [])
    |> Enum.join("\n")
  end

  defp lines_assemble([], _, _, line, acc), do: [line | acc] |> Enum.reverse()

  defp lines_assemble([word | rest], max, line_length, line, acc) do
    if line_length + 1 + String.length(word) > max do
      lines_assemble(rest, max, String.length(word), word, [line | acc])
    else
      lines_assemble(rest, max, line_length + 1 + String.length(word), line <> " " <> word, acc)
    end
  end
end
