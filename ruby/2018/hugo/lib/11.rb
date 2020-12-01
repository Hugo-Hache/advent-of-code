def power_level(x, y, serial_number)
  rack_id = x + 10
  power_level = rack_id * y
  power_level += serial_number
  power_level *= rack_id
  hundred_digit = power_level.to_s.split('')[-3].to_i
  hundred_digit - 5
end

def part_1(input, grid_size = 300)
  serial_number = input.to_i

  max_total_power = 0
  max_coords = nil
  power_levels = {}
  (1..(grid_size - 2)).each do |x|
    (1..(grid_size - 2)).each do |y|
      total_power = (x..(x + 2)).sum do |i|
        (y..(y + 2)).sum do |j|
          power_levels[[i, j]] ||= power_level(i, j, serial_number)
        end
      end
      next if total_power <= max_total_power

      max_total_power = total_power
      max_coords = [x, y]
    end
  end

  max_coords
end

def summed_area(table)
  size = table.size
  summed_area = Array.new(size) { Array.new(size) }

  summed_area[0][0] = table[0][0]
  (1..(size - 1)).each do |i|
    summed_area[0][i] = summed_area[0][i - 1] + table[0][i]
    summed_area[i][0] = summed_area[i - 1][0] + table[i][0]
  end

  (1..(size - 1)).each do |y|
    (1..(size - 1)).each do |x|
      summed_area[y][x] = table[y][x] + summed_area[y - 1][x] + summed_area[y][x - 1] - summed_area[y - 1][x - 1]
    end
  end

  summed_area
end

def part_2(input, grid_size = 300)
  serial_number = input.to_i

  powers = Array.new(grid_size) { Array.new(grid_size) }
  (0..(grid_size - 1)).each do |y|
    (0..(grid_size - 1)).each do |x|
      powers[y][x] = power_level(x + 1, y + 1, serial_number)
    end
  end

  summed_powers = summed_area(powers)

  max_total_power = 0
  max_coords = nil

  (0..(grid_size - 1)).each do |i|
    power = powers[i][0]
    next if power <= max_total_power
    max_total_power = power
    max_coords = [0, i + 1, 1]
  end

  (0..(grid_size - 1)).each do |i|
    power = powers[0][i]
    next if power <= max_total_power
    max_total_power = power
    max_coords = [i + 1, 0, 1]
  end

  (1..(grid_size - 1)).each do |y|
    (1..(grid_size - 1)).each do |x|
      max_size = grid_size - 1 - [x, y].max
      cell_max_total_power = 0
      cell_max_size = nil

      (0..max_size).each do |size|
        large = summed_powers[y + size][x + size]
        top = summed_powers[y - 1][x + size]
        left = summed_powers[y + size][x - 1]
        under = summed_powers[y - 1][x - 1]
        total_power = large - top - left + under
        next if total_power <= cell_max_total_power

        cell_max_total_power = total_power
        cell_max_size = size + 1
      end

      next if cell_max_total_power <= max_total_power

      max_total_power = cell_max_total_power
      max_coords = [x + 1, y + 1, cell_max_size]
    end
  end

  max_coords
end
