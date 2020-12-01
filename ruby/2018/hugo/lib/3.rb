require 'byebug'
class Fabric
  def initialize(size)
    @grid = Array.new(size) { Array.new(size) { [] } }
  end

  def cut(claim)
    id, _, coords, size = claim.split
    origin_x, origin_y = coords.split(',').map(&:to_i)
    width, height = size.split('x').map(&:to_i)

    (0..(width - 1)).each do |x|
      (0..(height - 1)).each do |y|
        @grid[origin_x + x][origin_y + y] << id
      end
    end
  end

  def conflict_area
    @grid.reduce(0) do |sum, row|
      sum + row.reduce(0) do |sub_sum, claim_ids|
        sub_sum + (claim_ids.length > 1 ? 1 : 0)
      end
    end
  end

  def clean_claim
    dirty_claims = {}
    clean_claims = {}
    @grid.each do |row|
      row.each do |claim_ids|
        if claim_ids.length == 1
          clean_id = claim_ids[0]
          clean_claims[clean_id] = true unless dirty_claims.key? clean_id
        else
          claim_ids.each do |id|
            clean_claims.delete(id)
            dirty_claims[id] = true
          end
        end
      end
    end
    clean_claims.keys.first
  end
end

def part_1(input)
  fabric = Fabric.new(1000)
  input.split("\n").each do |claim|
    fabric.cut(claim)
  end
  fabric.conflict_area
end

def part_2(input)
  fabric = Fabric.new(1000)
  input.split("\n").each do |claim|
    fabric.cut(claim)
  end
  fabric.clean_claim
end
