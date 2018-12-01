# Elixir Advent of Code Skeleton

A simple starter app for Advent of Code.

Using a fork of this repo you can run:

```elixir
mix aoc.gen DAY [--year YEAR]
```

Running `mix aoc.gen 1` (at the start of the 2018 advent of code) will:

* Generate a new module based on the title of the problem at
  `lib/aoc/year_2018/day_01/problem_title.ex`
* *Roughly* parse the html description of the problem into `@moduledoc` markdown.
* Use your session token to download your unique problem input into `priv`
* Generate a test file ready to solve the examples and pull in the saved problem
  input with tags (so slow running, complex days can be skipped later on).

## Installation

* Fork this repo
* Grab your browser's session key from [Advent Of Code](https://adventofcode.com) and set
  it as an environment variable. (Chrome Developer Tools > Application > Cookies > session)

## Using this Skeleton

* Run `mix aoc.gen 1` to generate your content for the first day
* Read the new module's docs, solve the first part of the problem with TDD :smile:.
* Run `mix aoc.gen 1` again to append the second part of the problem to your moduledocs.
* Get all the stars.
