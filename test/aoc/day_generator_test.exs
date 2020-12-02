defmodule Aoc.DayGeneratorTest do
  use ExUnit.Case

  alias Aoc.DayGenerator

  describe "title_from_body/1" do
    test "returns the title" do
      assert full_day_html() |> DayGenerator.title_from_body() == "High-Entropy Passphrases"
    end
  end

  describe "module_docs_from_body/1" do
    test "returns a combination of the parts" do
      result = full_day_html() |> DayGenerator.module_docs_from_body()
      assert result =~ "## --- Day 4"
    end
  end

  describe "find_and_append_moduledocs/2" do
    test "appends the string to the moduledocs" do
      result = DayGenerator.find_and_append_moduledocs(simple_docs(), "\n  ## Test")

      assert result =~ "## Te"
    end
  end

  def simple_docs,
    do: """
    defmodule Foo do
      @moduledoc \"\"\"
      This should be appended

      \"\"\"

      @doc \"\"\"
      Nothing here
      \"\"\"
      def nothing_here, do: nil
    end
    """

  def full_day_html,
    do: """
    <!DOCTYPE html>
    <html lang="en-us">
    <head>
    <meta charset="utf-8"/>
    <title>Day 4 - Advent of Code 2017</title>
    <!--[if lt IE 9]><script src="/static/html5.js"></script><![endif]-->
    <link href='//fonts.googleapis.com/css?family=Source+Code+Pro:300&subset=latin,latin-ext' rel='stylesheet' type='text/css'>
    <link rel="stylesheet" type="text/css" href="/static/style.css?15"/>
    <link rel="stylesheet alternate" type="text/css" href="/static/highcontrast.css?0" title="High Contrast"/>
    <link rel="shortcut icon" href="/favicon.ico?2"/>
    </head>
    <body>
    <header><div><h1 class="title-global"><a href="/">Advent of Code</a></h1><nav><ul><li><a href="/2017/about">[About]</a></li><li><a href="/2017/events">[Events]</a></li><li><a href="https://teespring.com/adventofcode" target="_blank">[Shop]</a></li><li><a href="/2017/settings">[Settings]</a></li><li><a href="/2017/auth/logout">[Log Out]</a></li></ul></nav><div class="user">Scott Taylor <span class="star-count">34*</span></div></div><div><h1 class="title-event">&nbsp;&nbsp;&nbsp;<span class="title-event-wrap">var y=</span><a href="/2017">2017</a><span class="title-event-wrap">;</span></h1><nav><ul><li><a href="/2017">[Calendar]</a></li><li><a href="/2017/support">[AoC++]</a></li><li><a href="/2017/sponsors">[Sponsors]</a></li><li><a href="/2017/leaderboard">[Leaderboard]</a></li><li><a href="/2017/stats">[Stats]</a></li></ul></nav></div></header>

    <div id="sidebar">
    <div id="sponsor"><div class="quiet">Our <a href="/2017/sponsors">sponsors</a> help make Advent of Code possible:</div><p><a href="http://www.novetta.com/careers?utm_campaign=Advent%20of%20Code%202017&amp;utm_source=www.adventofcode.com&amp;utm_medium=ad" target="_blank" onclick="if(ga)ga('send','event','sponsor','click',this.href);" rel="noopener">Novetta</a> - Unleash your imagination. Innovate at Novetta.</p></div>
    </div><!--/sidebar-->

    <main>
    <article class="day-desc"><h2>--- Day 4: High-Entropy Passphrases ---</h2><p>A new system policy has been put in place that requires all accounts to use a <em>passphrase</em> instead of simply a pass<em>word</em>. A passphrase consists of a series of words (lowercase letters) separated by spaces.</p>
    <p>To ensure security, a valid passphrase must contain no duplicate words.</p>
    <p>For example:</p>
    <ul>
    <li><code>aa bb cc dd ee</code> is valid.</li>
    <li><code>aa bb cc dd aa</code> is not valid - the word <code>aa</code> appears more than once.</li>
    <li><code>aa bb cc dd aaa</code> is valid - <code>aa</code> and <code>aaa</code> count as different words.</li>
    </ul>
    <p>The system's full passphrase list is available as your puzzle input. <em>How many passphrases are valid?</em></p>
    </article>
    <p>Your puzzle answer was <code>466</code>.</p><article class="day-desc"><h2 id="part2">--- Part Two ---</h2><p>For added security, <span title="Because as everyone knows, the number of rules is proportional to the level of security.">yet another system policy</span> has been put in place.  Now, a valid passphrase must contain no two words that are anagrams of each other - that is, a passphrase is invalid if any word's letters can be rearranged to form any other word in the passphrase.</p>
    <p>For example:</p>
    <ul>
    <li><code>abcde fghij</code> is a valid passphrase.</li>
    <li><code>abcde xyz ecdab</code> is not valid - the letters from the third word can be rearranged to form the first word.</li>
    <li><code>a ab abc abd abf abj</code> is a valid passphrase, because <em>all</em> letters need to be used when forming another word.</li>
    <li><code>iiii oiii ooii oooi oooo</code> is valid.</li>
    <li><code>oiii ioii iioi iiio</code> is not valid - any of these words can be rearranged to form any other word.</li>
    </ul>
    <p>Under this new system policy, <em>how many passphrases are valid?</em></p>
    </article>
    <p>Your puzzle answer was <code>251</code>.</p><p class="day-success">Both parts of this puzzle are complete! They provide two gold stars: **</p>
    <p>At this point, you should <a href="/2017">return to your advent calendar</a> and try another puzzle.</p>
    <p>If you still want to see it, you can <a href="4/input" target="_blank">get your puzzle input</a>.</p>
    <p>You can also <span class="share">[Share<span class="share-content">on
      <a href="https://twitter.com/intent/tweet?text=I%27ve+completed+%22High%2DEntropy+Passphrases%22+%2D+Day+4+%2D+Advent+of+Code+2017&amp;url=https%3A%2F%2Fadventofcode%2Ecom%2F2017%2Fday%2F4&amp;related=ericwastl&amp;hashtags=AdventOfCode" target="_blank">Twitter</a>
      <a href="http://www.reddit.com/submit?url=https%3A%2F%2Fadventofcode%2Ecom%2F2017%2Fday%2F4&amp;title=I%27ve+completed+%22High%2DEntropy+Passphrases%22+%2D+Day+4+%2D+Advent+of+Code+2017" target="_blank">Reddit</a
    ></span>]</span> this puzzle.</p>
    </main>
    </body>
    </html>
    """
end
