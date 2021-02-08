# TODO: Continue since 29.00 at https://alchemist.camp/episodes/minimal-todo-2

defmodule MinimalTodo do
  def start do
    load_csv()
    # (read todos, add todos, delete todos, load file, save files)
  end

  def get_command(data) do
    prompt = """
    Type the first letter of the command you want to run\n
    R)ead Todos    A)dd a Todo    D)elete a Todo    L)oad a .csv    S)ave a .csv
    """

    command =
      IO.gets(prompt)
      |> String.trim()
      |> String.downcase()

    case command do
      "r" -> show_todos(data)
      "a" -> add_todo(data)
      "d" -> delete_todos(data)
      "l" -> load_csv()
      "s" -> save_csv(data)
      "q" -> "Goodbye!"
      _ -> get_command(data)
    end
  end

  def prepare_csv(data) do
    # Insert string "Item" to the list of fields
    # eg, a = ["Hello", "Nunan"]
    #   then ["Item" | a] => ["Item", "Hello", "Nunan"]
    headers = ["Item" | get_fields(data)]

    items = Map.keys(data)
    item_rows = Enum.map(items, fn item -> [item | Map.values(data[item])] end)
    rows = [headers | item_rows]

    # `&(Enum.join(&1, ",")` is equivalent to `fn x -> Enum.join(x, ",") end`
    # by &1 is the first argument of the anonymous function
    # row_strings = Enum.map(rows, fn x -> Enum.join(x, ",") end)
    row_strings = Enum.map(rows, &Enum.join(&1, ","))
    Enum.join(row_strings, "\n")
  end

  def save_csv(data) do
    filename = IO.gets("Name of .csv to save: ") |> String.trim()
    filedata = prepare_csv(data)

    case File.write(filename, filedata) do
      :ok ->
        IO.puts("CSV saved")
        get_command(data)

      {:error, reason} ->
        IO.puts(~s(Could not save file "#{filename}"))
        IO.puts(~s("#{:file.format_error(reason)}"\n"))
        get_command(data)
    end
  end

  # def func_name(arg_1, arg_2? \\ true) = arg_2 is optional and default to true
  def show_todos(data, next_command? \\ true) do
    items = Map.keys(data)
    IO.puts("You have the following Todos:\n")
    Enum.each(items, fn item -> IO.puts(item) end)
    IO.puts("\n")

    if next_command? do
      get_command(data)
    end
  end

  def add_todo(data) do
    name = get_item_name(data)
    titles = get_fields(data)
    fields = Enum.map(titles, fn field -> field_from_user(field) end)
    new_todo = %{name => Enum.into(fields, %{})}
    new_data = Map.merge(data, new_todo)
    get_command(new_data)
  end

  def get_fields(data) do
    data[hd(Map.keys(data))] |> Map.keys()
  end

  def field_from_user(name) do
    field = IO.gets("#{name}: ") |> String.trim()

    case field do
      _ -> {name, field}
    end
  end

  def get_item_name(data) do
    name = IO.gets("Enter the name of the new todo: ") |> String.trim()

    if Map.has_key?(data, name) do
      IO.puts("Todo with that name already exists!\n")
      get_item_name(data)
    else
      name
    end
  end

  def delete_todos(data) do
    todo =
      IO.gets("Which todo would you like to delete?\n")
      |> String.trim()

    if Map.has_key?(data, todo) do
      IO.puts("ok.")
      new_map = Map.drop(data, [todo])
      IO.puts(~s("#{todo}" has been deleted.))
      get_command(new_map)
    else
      IO.puts(~s("There is no Todo named "#{todo}"!))
      show_todos(data, false)
      delete_todos(data)
    end
  end

  def load_csv() do
    filename = IO.gets("Name of .csv to load: ") |> String.trim()

    read(filename)
    |> parse()
    |> get_command()
  end

  def read(filename) do
    case File.read(filename) do
      {:ok, body} ->
        body

      {:error, reason} ->
        IO.puts(~s(Could not open file "#{filename}"\n))
        IO.puts(~s("#{:file.format_error(reason)}"\n))
        start()
    end
  end

  def parse(body) do
    [header | lines] = String.split(body, ~r{(\r\n|\r|\n)})
    titles = String.split(header, ",") |> tl()
    parse_lines(lines, titles)
  end

  def parse_lines(lines, titles) do
    Enum.reduce(lines, %{}, fn line, built ->
      [name | fields] = String.split(line, ",")

      if(Enum.count(fields) == Enum.count(titles)) do
        line_data = Enum.zip(titles, fields) |> Enum.into(%{})
        Map.merge(built, %{name => line_data})
      else
        built
      end
    end)
  end
end
