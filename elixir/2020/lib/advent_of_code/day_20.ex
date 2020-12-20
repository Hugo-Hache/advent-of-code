defmodule AdventOfCode.Day20 do
  def part1(input) do
    tiles =
      input
      |> String.split("\n\n")
      |> parse_tiles

    with_borders = tiles |> with_borders

    tiles
    |> Enum.filter(fn {_, {_, borders}} ->
      lonely_borders_count =
        borders
        |> Enum.count(&(with_borders |> Map.get(&1) |> length == 1))

      lonely_borders_count == 2
    end)
    |> Enum.reduce(1, fn {id, _}, total ->
      if id |> String.ends_with?("flipped"), do: total, else: String.to_integer(id) * total
    end)
  end

  def parse_tiles(tiles_lines) do
    tiles_lines
    |> Enum.reduce(%{}, fn tile, map ->
      [header | image_lines] = tile |> String.split("\n") |> Enum.filter(&(String.length(&1) > 0))
      %{"id" => id} = Regex.named_captures(~r/Tile (?<id>\d+):/, header)
      {image, flipped_image} = image_lines |> parse_images

      map
      |> Map.put(id, {image, borders(image)})
      |> Map.put(id <> "-flipped", {flipped_image, borders(flipped_image)})
    end)
  end

  def parse_images(image_lines) do
    size = length(image_lines)

    image_lines
    |> Enum.with_index()
    |> Enum.reduce({%{}, %{}}, fn {row, i}, {image, flipped_image} ->
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce({image, flipped_image}, fn {char, j}, {image, flipped_image} ->
        {
          image |> Map.put({i, j}, char),
          flipped_image |> Map.put({i, size - 1 - j}, char)
        }
      end)
    end)
  end

  def with_borders(tiles) do
    tiles
    |> Enum.reduce(%{}, fn {id, {_, borders}}, with_borders ->
      borders
      |> Enum.reduce(with_borders, fn border, with_border ->
        with_border |> Map.update(border, [id], &[id | &1])
      end)
    end)
  end

  def borders(image) do
    0..9
    |> Enum.reduce([[], [], [], []], fn n, [first_row, last_column, last_row, first_column] ->
      [
        [image |> Map.get({0, 9 - n}) | first_row],
        [image |> Map.get({9 - n, 9}) | last_column],
        [image |> Map.get({9, n}) | last_row],
        [image |> Map.get({n, 0}) | first_column]
      ]
    end)
  end

  def part2(input) do
    tiles =
      input
      |> String.split("\n\n")
      |> parse_tiles

    with_borders = tiles |> with_borders
    {top_left_corner_id, {_, top_left_borders}} = top_left_corner(tiles, with_borders)
    puzzle = %{{0, 0} => {top_left_corner_id, top_left_borders}}

    sea_monsters_image =
      tiles
      |> assemble(with_borders, puzzle, {0, 1})
      |> sea_monsters_filter(tiles)

    flipped_sea_monster_image = flip(sea_monsters_image)

    sea_monsters_images = [
      sea_monsters_image,
      rotate(sea_monsters_image, 1),
      rotate(sea_monsters_image, 2),
      rotate(sea_monsters_image, 3),
      flipped_sea_monster_image,
      rotate(flipped_sea_monster_image, 1),
      rotate(flipped_sea_monster_image, 2),
      rotate(flipped_sea_monster_image, 3)
    ]

    sea_monsters_images
    |> Enum.find(&(sea_monster_count(&1) > 0))
    |> water_roughness
  end

  def water_roughness(sea_monster_image) do
    all_count = sea_monster_image |> Map.values() |> Enum.count(&(&1 == "#"))
    all_count - 15 * (sea_monster_image |> sea_monster_count())
  end

  def sea_monster_count(sea_monster_image) do
    steps = [
      {1, 1},
      {0, 3},
      {-1, 1},
      {0, 1},
      {1, 1},
      {0, 3},
      {-1, 1},
      {0, 1},
      {1, 1},
      {0, 3},
      {-1, 1},
      {-1, 1},
      {1, 0},
      {0, 1}
    ]

    sea_monster_image
    |> Enum.count(fn
      {position, "#"} -> sea_monster_detector(sea_monster_image, position, steps)
      _ -> false
    end)
  end

  def sea_monster_detector(_, _, []), do: true

  def sea_monster_detector(sea_monster_image, {i, j}, [{di, dj} | next_steps]) do
    new_position = {i + di, j + dj}

    if Map.get(sea_monster_image, new_position) == "#" do
      sea_monster_detector(sea_monster_image, new_position, next_steps)
    else
      false
    end
  end

  def top_left_corner(tiles, with_borders) do
    tiles
    |> Enum.find(fn {_, {_, borders}} ->
      [top, _, _, left] =
        borders
        |> Enum.map(&(with_borders |> Map.get(&1) |> length))

      top == 1 && left == 1
    end)
  end

  def flipped_ids(id) do
    base_id = id |> String.split("-") |> hd

    [
      base_id,
      base_id <> "-flipped"
    ]
  end

  def assemble(tiles, _, puzzle, _) when map_size(puzzle) * 2 == map_size(tiles), do: puzzle

  def assemble(tiles, with_borders, puzzle, {i, j}) do
    left_compatible_tiles =
      case Map.get(puzzle, {i, j - 1}) do
        nil ->
          nil

        {_, [_, right_border, _, _]} ->
          target = right_border |> Enum.reverse()

          with_borders
          |> Map.get(target)
          |> not_used_in(puzzle)
          |> Enum.map(fn id ->
            {_, borders} = Map.get(tiles, id)
            offset = Enum.find_index(borders, &(&1 == target)) - 3
            rotated_borders = 0..3 |> Enum.map(&Enum.at(borders, rem(&1 + offset, 4)))
            {id, rotated_borders}
          end)
      end

    top_compatible_tiles =
      case Map.get(puzzle, {i - 1, j}) do
        nil ->
          nil

        {_, [_, _, bottom_border, _]} ->
          target = bottom_border |> Enum.reverse()

          with_borders
          |> Map.get(target)
          |> not_used_in(puzzle)
          |> Enum.map(fn id ->
            {_, borders} = Map.get(tiles, id)
            offset = Enum.find_index(borders, &(&1 == target)) - 4
            rotated_borders = 0..3 |> Enum.map(&Enum.at(borders, rem(&1 + offset, 4)))
            {id, rotated_borders}
          end)
      end

    compatible_tiles =
      case {left_compatible_tiles, top_compatible_tiles} do
        {nil, top} -> top
        {left, nil} -> left
        {left, top} -> left |> Enum.filter(&(&1 in top))
      end

    if compatible_tiles == [], do: IO.inspect({left_compatible_tiles, top_compatible_tiles})

    compatible_tile = hd(compatible_tiles)

    assemble(
      tiles,
      with_borders,
      puzzle |> Map.put({i, j}, compatible_tile),
      if((j + 1) * (j + 1) * 2 == map_size(tiles), do: {i + 1, 0}, else: {i, j + 1})
    )
  end

  def not_used_in(ids, puzzle) do
    ids
    |> Enum.filter(fn id ->
      flipped_ids(id)
      |> Enum.all?(fn id ->
        id not in (Map.values(puzzle) |> Enum.map(&elem(&1, 0)))
      end)
    end)
  end

  def draw_puzzle(puzzle, tiles, see_monsters \\ false) do
    {min_i, max_i} = puzzle |> Map.keys() |> Enum.map(&elem(&1, 0)) |> Enum.min_max()
    {min_j, max_j} = puzzle |> Map.keys() |> Enum.map(&elem(&1, 1)) |> Enum.min_max()

    IO.write("\n")

    Enum.each(min_i..max_i, fn i ->
      images =
        Enum.map(min_j..max_j, fn j ->
          case puzzle |> Map.get({i, j}) do
            nil ->
              nil

            {tile_id, rotated_borders} ->
              {image, borders} = tiles |> Map.get(tile_id)
              rotations = rotated_borders |> Enum.find_index(&(&1 == hd(borders)))
              rotate(image, rotations)
          end
        end)
        |> Enum.filter(& &1)

      range = unless see_monsters, do: 0..9, else: 1..8

      Enum.each(range, fn row ->
        images
        |> Enum.each(fn image ->
          Enum.each(range, fn column ->
            IO.write(image |> Map.get({row, column}))
          end)

          unless see_monsters, do: IO.write(" ")
        end)

        IO.write("\n")
      end)

      unless see_monsters, do: IO.write("\n")
    end)

    IO.write("\n")

    puzzle
  end

  def sea_monsters_filter(puzzle, tiles) do
    {min_i, max_i} = puzzle |> Map.keys() |> Enum.map(&elem(&1, 0)) |> Enum.min_max()
    {min_j, max_j} = puzzle |> Map.keys() |> Enum.map(&elem(&1, 1)) |> Enum.min_max()

    min_i..max_i
    |> Enum.reduce(%{}, fn i, sea_monsters_image ->
      images =
        Enum.map(min_j..max_j, fn j ->
          {tile_id, rotated_borders} = puzzle |> Map.get({i, j})
          {image, borders} = tiles |> Map.get(tile_id)
          rotations = rotated_borders |> Enum.find_index(&(&1 == hd(borders)))
          rotate(image, rotations)
        end)

      1..8
      |> Enum.reduce(sea_monsters_image, fn row, sea_monsters_image ->
        images
        |> Enum.with_index()
        |> Enum.reduce(sea_monsters_image, fn {image, j}, sea_monsters_image ->
          1..8
          |> Enum.reduce(sea_monsters_image, fn column, sea_monsters_image ->
            sea_monsters_image
            |> Map.put({i * 8 + row, j * 8 + column}, image |> Map.get({row, column}))
          end)
        end)
      end)
    end)
  end

  def draw(map) do
    {min_i, max_i} = map |> Map.keys() |> Enum.map(&elem(&1, 0)) |> Enum.min_max()
    {min_j, max_j} = map |> Map.keys() |> Enum.map(&elem(&1, 1)) |> Enum.min_max()

    IO.write("\n")

    Enum.each(min_i..max_i, fn i ->
      Enum.each(min_j..max_j, fn j ->
        IO.write(map |> Map.get({i, j}))
      end)

      IO.write("\n")
    end)

    IO.write("\n")

    map
  end

  def rotate(image, 0), do: image

  def rotate(image, count) do
    rotate(rotate(image), count - 1)
  end

  def rotate(image) do
    image
    |> Enum.reduce(%{}, fn {{i, j}, char}, rotated_image ->
      rotated_image |> Map.put({j, i}, char)
    end)
    |> Enum.reduce(%{}, fn {{i, j}, char}, rotated_image ->
      rotated_image |> Map.put({i, 9 - j}, char)
    end)
  end

  def flip(image) do
    max_i = image |> Map.keys() |> Enum.map(&elem(&1, 0)) |> Enum.max()

    image
    |> Enum.reduce(%{}, fn {{i, j}, char}, flipped_image ->
      flipped_image |> Map.put({max_i - i, j}, char)
    end)
  end
end
