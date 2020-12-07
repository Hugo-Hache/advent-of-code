defmodule AdventOfCode.Day07 do
  def part1(input) do
    input
    |> parse_direct_containers()
    |> possible_containers("shiny gold")
    |> MapSet.size()
  end

  def part2(input) do
    (input
     |> parse_direct_contents()
     |> contents_count("shiny gold")) - 1
  end

  def possible_containers(direct_containers, color, containers \\ MapSet.new()) do
    direct_containers
    |> Map.get(color, [])
    |> Enum.reduce(containers, fn {container_color, _}, containers ->
      MapSet.union(
        containers |> MapSet.put(container_color),
        possible_containers(direct_containers, container_color)
      )
    end)
  end

  def contents_count(contents, color) do
    contents
    |> Map.get(color, [])
    |> Enum.reduce(1, fn {content_color, content_count}, count ->
      count + content_count * contents_count(contents, content_color)
    end)
  end

  def parse_direct_containers(input) do
    input
    |> parse_rules(fn possible_containers, container_color, contained_color, contained_count ->
      container = {container_color, contained_count}

      possible_containers
      |> Map.update(
        contained_color,
        [container],
        &[container | &1]
      )
    end)
  end

  def parse_direct_contents(input) do
    input
    |> parse_rules(fn possible_content, container_color, content_color, content_count ->
      content = {content_color, String.to_integer(content_count)}

      possible_content
      |> Map.update(
        container_color,
        [content],
        &[content | &1]
      )
    end)
  end

  def parse_rules(input, reducer) do
    input
    |> String.split("\n")
    |> Enum.filter(&(String.length(&1) > 0))
    |> Enum.reduce(%{}, fn line, map ->
      %{"container_color" => container_color, "containeds" => containeds} =
        Regex.named_captures(~r/(?<container_color>.*) bags contain (?<containeds>.*)/, line)

      if containeds == "no other bags." do
        map
      else
        containeds
        |> String.split(", ")
        |> Enum.reduce(map, fn rule, map ->
          %{"contained_count" => contained_count, "contained_color" => contained_color} =
            Regex.named_captures(
              ~r/(?<contained_count>\d+) (?<contained_color>.+) bags?\.?/,
              rule
            )

          reducer.(map, container_color, contained_color, contained_count)
        end)
      end
    end)
  end
end
