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
        if number_at(row, col) == number_at(row, col-1) && !empty?(col, row) && !added.include?([col, row]) && !added.include?([col-1, row])
          sum = number_at(row, col-1) * 2
          @board.put_number(sum, row, col)
          added << [col, row]
          make_empty(col-1, row)
        end
      end
    end
  end

  def number_at(row, col)
    @board.get_number(row, col)
  end

  def merge_neighbours_left(added)
    0.upto(@board.size-1) do |row|
      (0).upto(@board.size-2) do |col|
        if number_at(row, col) == number_at(row, col+1) && !empty?(col, row) && !added.include?([col, row])  && !added.include?([col+1, row])
          sum = number_at(row, col+1) * 2
          @board.put_number(sum, row, col)
          added << [col, row]
          make_empty(col+1, row)
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
    @board.put_number(number_at(row, col), row, col+1)
  end

  def copy_this_to_left(col, row)
    @board.put_number(number_at(row, col), row, col-1)
  end

  def empty?(col, row)
    @board.empty?(row, col)
  end

  def make_empty(col, row)
    @board.put_number(0, row, col)
  end

end

class GameFinishedException < StandardError
end
