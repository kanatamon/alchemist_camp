# TODO: Finish the challenge 2 on https://alchemist.camp/episodes/word-count

# `a \> b` this syntax is called "Pipeline"
# it make value of `a` as the first argument of `b` function
filename =
  IO.gets("File to operate: ")
  |> String.trim()

operation =
  IO.gets("Operations
  [1] - Count words
  [2] - Count lines
  [3] - Count characters including numberic
Type operation: ")
  |> String.trim()

# `!` in below is a `bang`
# normally calling `File.read()` will return either ok or error
# but with `!`(bang) this will force function to throw error
body = File.read!(filename)

case operation do
  "1" ->
    body
    # Note: the `~r` is regex
    #  , split by none-word and apostrophe `[^\w']` or new line `\\n`
    |> String.split(~r{(\\n|[^\w'])+})
    # Note: `fn x -> x != "" end` this is a anonymous function
    |> Enum.filter(fn x -> x != "" end)
    |> Enum.count()
    |> IO.puts()

  "2" ->
    body
    |> String.split(~r{\n})
    |> Enum.count()
    |> IO.puts()

  "3" ->
    body
    |> String.graphemes()
    |> Enum.filter(fn x -> String.match?(x, ~r{(\w|\d)}) end)
    |> Enum.count()
    |> IO.puts()
end
