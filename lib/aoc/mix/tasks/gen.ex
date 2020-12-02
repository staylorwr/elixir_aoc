defmodule Mix.Tasks.Aoc.Gen do
  @moduledoc """
  Mix task for generating a scaffold for a day of Advent of Code

  It expects the day of the competition as an argument

      mix aoc.gen DAY [--year YEAR]

  A module will be created at `lib/aoc/year_{YEAR}/day_{DAY}/{task_name}.ex`.

  The generator will also attempt to create:

  - a test file
  - a file containing the test input in `/priv/static`
  """
  use Mix.Task

  @shortdoc "Generates a scaffold for a day of advent of code"

  @switches [year: :string]

  def run(argv) do
    Mix.Task.run("app.start")

    case parse_opts(argv) do
      {_opts, []} ->
        Mix.raise("A day is required")

      {opts, [day]} ->
        generate(day, opts)
    end
  end

  defp generate(day, year: year) do
    case Aoc.Site.get_day(year, day) do
      {:ok, %{status: 200, body: body}} ->
        Aoc.DayGenerator.generate(day, year, body)

      {:ok, %{status: status, body: body}} ->
        Mix.raise("HTTP Error #{status}: #{body}")
    end
  end

  defp generate(day, []) do
    year = Date.utc_today() |> Map.get(:year) |> Integer.to_string()
    generate(day, year: year)
  end

  defp parse_opts(argv) do
    case OptionParser.parse(argv, strict: @switches) do
      {opts, argv, []} ->
        {opts, argv}

      {_opts, _argv, [switch | _]} ->
        Mix.raise("Invalid option: " <> switch_to_string(switch))
    end
  end

  defp switch_to_string({name, nil}), do: name
  defp switch_to_string({name, val}), do: name <> "=" <> val
end
