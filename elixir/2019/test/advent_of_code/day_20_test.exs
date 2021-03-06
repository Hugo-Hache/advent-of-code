defmodule AdventOfCode.Day20Test do
  use ExUnit.Case

  import AdventOfCode.Day20

  test "part1" do
    input = """
             A
             A
      #######.#########
      #######.........#
      #######.#######.#
      #######.#######.#
      #######.#######.#
      #####  B    ###.#
    BC...##  C    ###.#
      ##.##       ###.#
      ##...DE  F  ###.#
      #####    G  ###.#
      #########.#####.#
    DE..#######...###.#
      #.#########.###.#
    FG..#########.....#
      ###########.#####
                 Z
                 Z
    """
    assert part1(input) == 23
  end

  test "part2" do
    input = """
                 Z L X W       C
                 Z P Q B       K
      ###########.#.#.#.#######.###############
      #...#.......#.#.......#.#.......#.#.#...#
      ###.#.#.#.#.#.#.#.###.#.#.#######.#.#.###
      #.#...#.#.#...#.#.#...#...#...#.#.......#
      #.###.#######.###.###.#.###.###.#.#######
      #...#.......#.#...#...#.............#...#
      #.#########.#######.#.#######.#######.###
      #...#.#    F       R I       Z    #.#.#.#
      #.###.#    D       E C       H    #.#.#.#
      #.#...#                           #...#.#
      #.###.#                           #.###.#
      #.#....OA                       WB..#.#..ZH
      #.###.#                           #.#.#.#
    CJ......#                           #.....#
      #######                           #######
      #.#....CK                         #......IC
      #.###.#                           #.###.#
      #.....#                           #...#.#
      ###.###                           #.#.#.#
    XF....#.#                         RF..#.#.#
      #####.#                           #######
      #......CJ                       NM..#...#
      ###.#.#                           #.###.#
    RE....#.#                           #......RF
      ###.###        X   X       L      #.#.#.#
      #.....#        F   Q       P      #.#.#.#
      ###.###########.###.#######.#########.###
      #.....#...#.....#.......#...#.....#.#...#
      #####.#.###.#######.#######.###.###.#.#.#
      #.......#.......#.#.#.#.#...#...#...#.#.#
      #####.###.#####.#.#.#.#.###.###.#.###.###
      #.......#.....#.#...#...............#...#
      #############.#.#.###.###################
                   A O F   N
                   A A D   M
    """

    assert part2(input) == 396
  end
end
