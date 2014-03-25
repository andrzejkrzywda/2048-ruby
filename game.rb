class Game

  attr_reader :board

  def initialize(board)
    @board = board
  end

  def play
    raise GameFinishedException.new if @board.full?
    @board.put_at_random_location(2)
  end


  def play_right
    already_added = []
    (@board.size-2).times { add_and_move_right(already_added) }
  end


  def play_left
    already_added = []
    (@board.size-2).times { add_and_move_left(already_added) }
  end

  def add_and_move_right(added)
    move_right_to_empty
    merge_neighbours_right(added)
  end

  def add_and_move_left(added)
    move_left_to_empty
    merge_neighbours_left(added)
  end


  def merge_neighbours_right(added)
    0.upto(@board.size-1) do |row|
      (@board.size-1).downto(1) do |col|
        current = Location.new(row, col)
        left = Location.new(row, col-1)
        sum!(current, left, added) if possible_to_sum?(current, left, added)
      end
    end
  end

  def sum!(location, other_location, added)
    double_number!(location)
    added << [location]
    make_empty(other_location)
  end

  def possible_to_sum?(current, other, added)
    same?(current, other) && !empty?(current) && not_yet_added?(added, current, other)
  end

  def not_yet_added?(added, location, other_location)
    !added.include?([location]) && !added.include?([other_location])
  end

  def double_number!(location)
    put_number(number_at(location) * 2, location)
  end

  def same?(location, other_location)
    number_at(location) == number_at(other_location)
  end

  def put_number(sum, location)
    @board.put_number(sum, location)
  end

  def number_at(location)
    @board.get_number(location)
  end

  def merge_neighbours_left(added)
    0.upto(@board.size-1) do |row|
      (0).upto(@board.size-2) do |col|
        current = Location.new(row, col)
        right = Location.new(row, col+1)
        sum!(current, right, added) if possible_to_sum?(current, right, added)
      end
    end
  end

  def move_right_to_empty
    0.upto(@board.size-1) do |row|
      (0).upto(@board.size-1) do |col|
        current = Location.new(row, col)
        right = Location.new(row, col+1)
        if empty?(right)   && !empty?(current)
          copy_this_to(current, right)
          make_empty(current)
        end
      end
    end
  end

  def move_left_to_empty
    0.upto(@board.size-1) do |row|
      (@board.size-1).downto(1) do |col|
        current = Location.new(row, col)
        left = Location.new(row, col-1)
        if empty?(left)  && !empty?(current)
          copy_this_to(current, left)
          make_empty(current)
        end
      end
    end
  end

  def copy_this_to(current, right)
    put_number(number_at(current), right)
  end


  def empty?(location)
    @board.empty?(location)
  end

  def make_empty(location)
    put_number(0, location)
  end

end

class GameFinishedException < StandardError
end
