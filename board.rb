require 'matrix'

# hack - ruby Matrix is immutable by default

Matrix.send(:public, :[]=)


class Board
  attr_reader :size, :matrix
  def initialize(size=0)
    @size = size
    @matrix = new_square_matrix(size, 0)
  end

  def put_number(number, location)
    @matrix[location.row, location.col] = number
  end

  def get_number(location)
    @matrix.component(location.row, location.col)
  end

  def full?
    ! as_flatten_list.any?{|e| e == 0}
  end

  def as_flatten_list
    @matrix.to_a.flatten
  end

  def empty_fields_count
    as_flatten_list.count{|e| e == 0}
  end

  def put_at_random_location(number)
    location = empty_locations.sample
    put_number(number, location)
  end

  def empty_locations
    result = []

    0.upto(@size-1) {|row| 0.upto(@size-1) do |col|
      location = Location.new(row, col); result << location if empty?(location)
    end
    }
    return result
  end

  def each_vertical_pair_from_top_right
    0.upto(@size-1) do |row|
      (@size-1).downto(1) do |col|
        yield(Location.new(row, col), Location.new(row, col-1))
      end
    end
  end

  def each_verticail_pair_from_top_left
    0.upto(size-1) do |row|
      (0).upto(size-2) do |col|
        yield(Location.new(row, col), Location.new(row, col+1))
      end
    end
  end

  def to_s
    string = "\n"
    0.upto(@size-1) do |row|
      0.upto(@size-1) do |col|
        string += get_number(Location.new(row, col)).to_s
      end
      string << "\n"
    end
    string << "\n"
    string
  end

  def empty?(location)
    get_number(location) == 0
  end

  def get_row(row)
    @matrix.row(row).to_a
  end

  def set_row(row, string)
    0.upto(string.size-1) do |i|
      put_number(string.scan(/\w/)[i].to_i, Location.new(row, i))
    end
  end

  private

  def new_square_matrix(size, default_element)
    Matrix.rows(rows(size, default_element))
  end

  def rows(size, default_element)
    Array.new(size, empty_row(size, default_element))
  end

  def empty_row(size, default_element)
    Array.new(size, default_element)
  end
end

class Location
  attr_accessor :row, :col
  def initialize(row, col)
    @row = row
    @col = col
  end

  def ==(other)
    @row == other.row && @col == other.col
  end
end
