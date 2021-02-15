defmodule MiniMarkdown do
  def to_html(text) do
    text
    |> h1()
    |> h2()
    |> p()
    |> bold()
    |> italics()
  end

  def italics(text) do
    # Regex of matches *anything* in asterisk
    # (.*) - means anythins
    # \\1 - means replace the matches at that mark
    Regex.replace(~r/\*(.*)\*/, text, "<em>\\1</em>")
  end

  def bold(text) do
    Regex.replace(~r/\*\*(.*)\*\*/, text, "<strong>\\1</strong>")
  end

  def p(text) do
    # \r\n and \r - is new line in Windown OS
    # ((\r\n|\r|\n)+$)? - means end of new lines or nothing
    # ([^#<][^\r\n]+) - the very first character can's be(^) neither # or <
    Regex.replace(~r/(\r\n|\r|\n|^)+([^#<][^\r\n]+)((\r\n|\r|\n)+$)?/, text, "<p>\\2</p>")
  end

  def h1(text) do
    Regex.replace(~r/(\r\n|\r|\n|^)\#\s+([^#][^\n\r]+)((\r\n|\r|\n)+$)?/, text, "<h1>\\2</h1>")
  end

  def h2(text) do
    Regex.replace(~r/(\r\n|\r|\n|^)\#\#\s+([^#][^\n\r]+)((\r\n|\r|\n)+$)?/, text, "<h2>\\2</h2>")
  end

  def test_str do
    """
    # Main title of my doc

    ## A less important header

    I *really* disagree with you

    You can **strongly** emphasize text

    You can make lists of

    1) One
    2) Two
    3) Three

    things!
    """
  end
end
