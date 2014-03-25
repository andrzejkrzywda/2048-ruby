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
    0.upto(@board.size-1) do |row_index|
      (@board.size-1).downto(1) do |col_index|
        if @board.get_number(row_index, col_index) == @board.get_number(row_index, col_index-1) && !empty?(col_index, row_index) && !added.include?([col_index, row_index]) && !added.include?([col_index-1, row_index])
          sum = @board.get_number(row_index, col_index-1) * 2
          @board.put_number(sum, row_index, col_index)
          added << [col_index, row_index]
          make_empty(col_index-1, row_index)
        end
      end
    end
  end

  def merge_neighbours_left(added)
    0.upto(@board.size-1) do |row_index|
      (0).upto(@board.size-2) do |col_index|
        if @board.get_number(row_index, col_index) == @board.get_number(row_index, col_index+1) && !empty?(col_index, row_index) && !added.include?([col_index, row_index])  && !added.include?([col_index+1, row_index])
          sum = @board.get_number(row_index, col_index+1) * 2
          @board.put_number(sum, row_index, col_index)
          added << [col_index, row_index]
          make_empty(col_index+1, row_index)
        end
      end
    end
  end

  def move_right_to_empty
    0.upto(@board.size-1) do |row_index|
      (0).upto(@board.size-1) do |col_index|
        if empty?(col_index+1, row_index)   && !empty?(col_index, row_index)
          copy_this_to_right(col_index, row_index)
          make_empty(col_index, row_index)
        end
      end
    end
  end

  def move_left_to_empty
    0.upto(@board.size-1) do |row_index|
      (@board.size-1).downto(1) do |col_index|
        if empty?(col_index-1, row_index)  && !empty?(col_index, row_index)
          copy_this_to_left(col_index, row_index)
          make_empty(col_index, row_index)
        end
      end
    end
  end

  def copy_this_to_right(col_index, row_index)
    @board.put_number(@board.get_number(row_index, col_index), row_index, col_index+1)
  end

  def copy_this_to_left(col_index, row_index)
    @board.put_number(@board.get_number(row_index, col_index), row_index, col_index-1)
  end

  def empty?(col_index, row_index)
    @board.empty?(row_index, col_index)
  end

  def make_empty(col_index, row_index)
    @board.put_number(0, row_index, col_index)
  end

end

class GameFinishedException < StandardError
end
