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
    @board.each_vertical_pair_from_top_right do |current, left|
      sum!(current, left, added) if possible_to_sum?(current, left, added)
    end
  end

  def merge_neighbours_left(added)
    @board.each_verticail_pair_from_top_left do |current, right|
      sum!(current, right, added) if possible_to_sum?(current, right, added)
    end
  end

  def move_right_to_empty
    @board.each_verticail_pair_from_top_left do |current, right|
      move(current, right) if can_move?(current, right)
    end
  end

  def move_left_to_empty
    @board.each_vertical_pair_from_top_right do |current, left|
      move(current, left) if can_move?(current, left)
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

  def move(from, to)
    copy_this_to(from, to)
    make_empty(from)
  end

  def can_move?(from, to)
    ! empty?(from) && empty?(to)
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
