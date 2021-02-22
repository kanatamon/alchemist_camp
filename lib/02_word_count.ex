defmodule WordCount do
  def start(parsed, filename, invalid) do
    if invalid != [] or filename == "h" do
      show_help()
    else
      read_file(parsed, filename)
    end
  end

  def show_help() do
    IO.puts("""
    Usage: [filename] [-flags]
    Flags:
    -l    displays line count
    -c    displays character count
    -w    displays word count (default)
    Multiply flags may be used. Exampler usage to display line and character count:

    somefile.txt -lc

    """)
  end

  def read_file(parsed, filename) do
    flags =
      case Enum.count(parsed) do
        0 -> [:words]
        _ -> Enum.map(parsed, &elem(&1, 0))
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
        :lines -> IO.puts("Lines: #{Enum.count(lines)}")
        :words -> IO.puts("Words: #{Enum.count(words)}")
        :chars -> IO.puts("Chars: #{Enum.count(chars)}")
        _ -> nil
      end
    end)
  end
end
