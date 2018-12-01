defmodule Aoc.DayGenerator do
  @moduledoc """
  Helper for generating a day's skeleton from the body of the problem's page
  """

  def generate(day, year, body) do
    {day, year, body}
    |> check_if_already_exists()
    |> generate_day_file()
    |> generate_test()
    |> generate_input()
  end

  defp check_if_already_exists({day, year, body}) do
    with false <- folder_exists?(day, year) do
      Mix.shell().info("No files exist yet of Day #{day} of Year #{year}")
      {day, year, body}
    else
      true -> handle_files_exist({day, year, body})
    end
  end

  @continue "Files exist for this problem.  Do you want to overwrite them?"

  def handle_files_exist({day, year, body} = args) do
    with false <- day_contains_part_two?(args),
         true <- body_contains_part_two?(body) do
      Mix.shell().info("Adding part two to the docs")

      part_2 = part_2_docs_from_body(body)

      new_body =
        args
        |> read_day_file()
        |> find_and_append_moduledocs(part_2)

      write_day_file(args, new_body)

      false
    else
      _ ->
        case Mix.shell().yes?(@continue) do
          true -> {day, year, body}
          false -> false
        end
    end
  end

  defp read_day_file({day, year, body}) do
    title = title_from_body(body)
    file_name = title |> String.replace(" ", "_") |> String.downcase()

    "#{file_folder(day, year)}/#{file_name}.ex"
    |> File.read!()
  end

  defp write_day_file({day, year, body}, content) do
    title = title_from_body(body)
    file_name = title |> String.replace(" ", "_") |> String.downcase()
    File.write!("#{file_folder(day, year)}/#{file_name}.ex", content)
  end

  defp day_contains_part_two?(args) do
    args
    |> read_day_file()
    |> String.contains?("## --- Part Two ---")
  end

  defp body_contains_part_two?(body) do
    body
    |> Floki.find(".day-desc #part2")
    |> Enum.any?()
  end

  defp generate_day_file({day, year, body}) do
    title = title_from_body(body)
    module_name = title |> String.replace(" ", "") |> String.trim()

    content =
      EEx.eval_file("priv/templates/main_module.eex",
        year: year,
        day: String.pad_leading(day, 2, "0"),
        title: module_name,
        module_documentation: module_docs_from_body(body)
      )

    File.mkdir_p(file_folder(day, year))
    write_day_file({day, year, body}, content)
    Mix.shell().info("Created Main Module")
    {day, year, body}
  end

  defp generate_day_file(false), do: false

  defp generate_test({day, year, body}) do
    title = title_from_body(body)
    file_name = title |> String.replace(" ", "_") |> String.downcase()
    module_name = title |> String.replace(" ", "") |> String.trim()

    content =
      EEx.eval_file("priv/templates/test_file.eex",
        year: year,
        day: String.pad_leading(day, 2, "0"),
        title: module_name
      )

    File.mkdir_p(test_file_folder(day, year))
    File.write!("#{test_file_folder(day, year)}/#{file_name}_test.exs", content)
    Mix.shell().info("Created Test File")
    {day, year, body}
  end

  defp generate_test(false), do: false

  defp generate_input({day, year, _body}) do
    case get_input(day, year) do
      %HTTPoison.Response{status_code: 200, body: body} ->
        File.mkdir_p(input_file_folder(year))

        File.write!(
          "#{input_file_folder(year)}/day_#{String.pad_leading(day, 2, "0")}.txt",
          body |> String.trim()
        )

        Mix.shell().info("Created Input File")

      %HTTPoison.Response{status_code: code, body: body} ->
        Mix.raise("Test Input HTTP Error #{code}: #{body}")
    end
  end

  defp generate_input(false), do: false

  defp folder_exists?(day, year) do
    day
    |> file_folder(year)
    |> Path.expand()
    |> File.exists?()
  end

  defp file_folder(day, year) do
    "lib/aoc/year_#{year}/day_#{String.pad_leading(day, 2, "0")}"
  end

  defp test_file_folder(day, year) do
    "test/aoc/year_#{year}/day_#{String.pad_leading(day, 2, "0")}"
  end

  defp input_file_folder(year) do
    "priv/inputs/year_#{year}"
  end

  @prepend_title_pattern ~r/--- Day \d+:/

  def title_from_body(body) do
    body
    |> Floki.find("article h2")
    |> List.first()
    |> Floki.text()
    |> String.replace(@prepend_title_pattern, "")
    |> String.replace(" ---", "")
    |> String.trim()
  end

  def module_docs_from_body(body) do
    body
    |> Floki.find("article")
    |> document_to_markdown()
  end

  def part_2_docs_from_body(body) do
    [_part_1, part_2] = Floki.find(body, "article")
    document_to_markdown([part_2])
  end

  defp document_to_markdown(doc) do
    doc
    |> Enum.map(&to_markdown/1)
    |> Enum.join("\n")
    |> String.replace("\n", "\n  ")
    |> String.replace_prefix("##", "  ##")
  end

  defp to_markdown({element, _attrs, [content]}) when is_bitstring(content) do
    partial_to_markdown(element, content)
  end

  defp to_markdown(content) when is_bitstring(content), do: content

  defp to_markdown({element, _attrs, content}) do
    inner_markdown = Enum.map(content, &to_markdown/1) |> Enum.join()
    partial_to_markdown(element, inner_markdown)
  end

  defp partial_to_markdown(element, content) do
    case element do
      "h2" -> "## #{content} \n\n"
      "em" -> "*#{content}*"
      "code" -> "`#{content}`"
      "p" -> "#{Aoc.WordWrap.paragraph(content, 80)} \n\n"
      "li" -> "- #{content} \n"
      _ -> content
    end
  end

  defp get_input(day, year) do
    session_cookie = Application.get_env(:aoc, :key)

    "https://adventofcode.com/#{year}/day/#{day}/input"
    |> HTTPoison.get!(%{}, hackney: [cookie: ["session=#{session_cookie}"]])
  end

  def find_and_append_moduledocs(body, docs) do
    [{first, _length} | _] = Regex.run(~r/  """\n/, body, return: :index)

    {part_1, part_2} = String.split_at(body, first-8)

    part_1 <> "\n"<> String.slice(docs, 0..-3) <> part_2
  end
end
