require 'test/unit'
require './board'


class BoardTest < Test::Unit::TestCase
  def test_setting_numbers
    board = Board.new(2)
    board.put_number(5, 1, 1)
    assert_equal(5, board.get_number(1, 1))
  end

  def test_full
    board = Board.new(2)
    board.put_number(1, 0, 0)
    board.put_number(1, 0, 1)
    board.put_number(1, 1, 0)
    board.put_number(1, 1, 1)
    assert_equal(true, board.full?)
  end

  def test_not_full
    board = Board.new(2)
    assert_equal(false, board.full?)
  end

  def test_number_of_empty
    board = Board.new(2)
    assert_equal(4, board.empty_fields_count)
    board.put_number(1, 1, 1)
    assert_equal(3, board.empty_fields_count)
  end

  def test_put_at_random_location
    board = Board.new(2)
    board.put_at_random_location(2)
    assert_equal(3, board.empty_fields_count)
  end

  def test_empty_locations
    board = Board.new(2)
    assert_equal 4, board.empty_locations.count
  end

end
