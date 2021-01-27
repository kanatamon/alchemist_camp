# `a \> b` this syntax is called "Pipeline"
# it make value of `a` as the first argument of `b` function
filename =
  IO.gets("File to count the words from (h for help):\n ")
  |> String.trim()

if filename == "h" do
  IO.puts("""
  Usage: [filename] [-flags]
  Flags:
  -l    displays line count
  -c    displays character count
  -w    displays word count (default)
  Multiply flags may be used. Exampler usage to display line and character count:

  somefile.txt -lc

  """)
else
  parts = String.split(filename, "-")
  filename = List.first(parts) |> String.trim()

  flags =
    case Enum.at(parts, 1) do
      nil -> ["w"]
      chars -> String.split(chars, "") |> Enum.filter(fn x -> x != "" end)
    end

  # `!` in below is a `bang`
  # normally calling `File.read()` will return either ok or error
  # but with `!`(bang) this will force function to throw error
  body = File.read!(filename)

  # WHAT?: \r\n | \r
  lines = String.split(body, ~r{(\r\n|\n|\r)})

  # Note: the `~r` is regex
  #  , split by none-word and apostrophe `[^\w']` or new line `\\n`
  words =
    String.split(body, ~r{(\\n|[^\w'])+})
    |> Enum.filter(fn x -> x != "" end)

  chars = String.split(body, "") |> Enum.filter(fn x -> x != "" end)

  Enum.each(flags, fn flag ->
    case flag do
      "l" -> IO.puts("Lines: #{Enum.count(lines)}")
      "w" -> IO.puts("Words: #{Enum.count(words)}")
      "c" -> IO.puts("Chars: #{Enum.count(chars)}")
      _ -> nil
    end
  end)
end
