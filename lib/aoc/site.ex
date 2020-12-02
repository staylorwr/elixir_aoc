defmodule Aoc.Site do
  use Tesla

  def get_input(year, day) do
    Tesla.get(client(), "/#{year}/day/#{day}/input")
  end

  def get_day(year, day) do
    Tesla.get(client(), "/#{year}/day/#{day}")
  end

  def client do
    session_cookie = Application.get_env(:aoc, :key)

    middleware = [
      {Tesla.Middleware.BaseUrl, "https://adventofcode.com"},
      {Tesla.Middleware.Headers,
       [
         {"Cookie", "session=#{session_cookie}"}
       ]}
    ]

    Tesla.client(middleware)
  end
end
