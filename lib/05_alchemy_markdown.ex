defmodule AlchemyMarkdown do
  def to_html(markdown) do
    markdown
    |> earmark()
    |> big()
    |> small()
    |> hrs()
  end

  def earmark(markdown) do
    Earmark.as_html!(markdown || "", %Earmark.Options{smartypants: false})
  end

  def big(text) do
    Regex.replace(~r/\+\+(.*)\+\+/, text, "<big>\\1</big>")
  end

  def small(text) do
    Regex.replace(~r/\-\-(.*)\-\-/, text, "<small>\\1</small>")
  end

  def hrs(text) do
    # * - mean 0 or more
    #   eg. \s*, mean zero or more spaces
    Regex.replace(~r{(^|\r\n|\r|\n)([-*])(\s*\2\s*)+\2}, text, "\\1<hr />")
  end
end
