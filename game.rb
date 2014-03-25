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
        if possible_to_sum?(row, col, row, col-1, added)
          sum!(col, row, col-1, row, added)
        end
      end
    end
  end

  def sum!(col, row, other_col, other_row, added)
    double_number!(col, row)
    added << [col, row]
    make_empty(other_col, other_row)
  end

  def possible_to_sum?(row, col, other_row, other_col, added)
    same?(row, col, other_row, other_col) && !empty?(col, row) && !added.include?([col, row]) && !added.include?([col-1,other_row])
  end

  def double_number!(col, row)
    put_number(number_at(row, col) * 2, row, col)
  end

  def same?(row, col, other_row, other_col)
    number_at(row, col) == number_at(other_row, other_col)
  end

  def put_number(sum, row, col)
    @board.put_number(sum, row, col)
  end

  def number_at(row, col)
    @board.get_number(row, col)
  end

  def merge_neighbours_left(added)
    0.upto(@board.size-1) do |row|
      (0).upto(@board.size-2) do |col|
        if possible_to_sum?(row, col, row, col+1, added)
          sum!(col, row, col+1, row, added)
        end
      end
    end
  end

  def move_right_to_empty
    0.upto(@board.size-1) do |row|
      (0).upto(@board.size-1) do |col|
        if empty?(col+1, row)   && !empty?(col, row)
          copy_this_to_right(col, row)
          make_empty(col, row)
        end
      end
    end
  end

  def move_left_to_empty
    0.upto(@board.size-1) do |row|
      (@board.size-1).downto(1) do |col|
        if empty?(col-1, row)  && !empty?(col, row)
          copy_this_to_left(col, row)
          make_empty(col, row)
        end
      end
    end
  end

  def copy_this_to_right(col, row)
    put_number(number_at(row, col), row, col+1)
  end

  def copy_this_to_left(col, row)
    put_number(number_at(row, col), row, col-1)
  end

  def empty?(col, row)
    @board.empty?(row, col)
  end

  def make_empty(col, row)
    put_number(0, row, col)
  end

end

class GameFinishedException < StandardError
end
