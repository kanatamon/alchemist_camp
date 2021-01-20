# TODO: Finish the challenge 2 on https://alchemist.camp/episodes/word-count

# `a \> b` this syntax is called "Pipeline"
# it make value of `a` as the first argument of `b` function
filename = IO.gets("File to count the words from: ")
  |> String.trim()

# `!` in below is a `bang`
# normally calling `File.read()` will return either ok or error
# but with `!`(bang) this will force function to throw error
words =
  File.read!(filename)
  # Note: the `~r` is regex
  #  , split by none-word and apostrophe `[^\w']` or new line `\\n`
  |> String.split(~r{(\\n|[^\w'])+})
  # Note: `fn x -> x != "" end` this is a anonymous function
  |> Enum.filter(fn x -> x != "" end)

# IO.inspect(words)

words |> Enum.count() |> IO.puts()
