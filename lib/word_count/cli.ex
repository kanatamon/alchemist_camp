defmodule WordCount.CLI do
  def main(args) do
    {parsed, args, invalid} =
      OptionParser.parse(
        args,
        switches: [chars: nil, lines: nil, words: nil],
        aliases: [c: :chars, l: :lines, w: :words]
      )

    filename = hd(args)
    WordCount.start(parsed, filename, invalid)
  end
end
