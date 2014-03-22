require 'test/unit'
require './game'
require './board'

class GameTest < Test::Unit::TestCase
  def test_game_finished_when_board_full
    board = Board.new(2)
    board.put_number(1, 0, 0)
    board.put_number(1, 0, 1)
    board.put_number(1, 1, 0)
    board.put_number(1, 1, 1)
    game = Game.new(board)
    assert_raises GameFinishedException do
      game.play
    end
  end

  def test_game_adds_new_numbers
    board = Board.new(2)
    game = Game.new(board)
    game.play
    game.play
    game.play
    game.play
    assert_equal(0, board.empty_fields_count)
  end


  def test_game_move_right
    assert_row_after_move_right(new_game, 0, "0002", "0002")
    assert_row_after_move_right(new_game, 0, "0200", "0002")

    assert_row_after_move_right(new_game, 0, "0202", "0004")
    assert_row_after_move_right(new_game, 0, "2002", "0004")
    assert_row_after_move_right(new_game, 0, "2020", "0004")
    assert_row_after_move_right(new_game, 0, "2200", "0004")

    assert_row_after_move_right(new_game, 0, "2022", "0024")
    assert_row_after_move_right(new_game, 0, "2000", "0002")
    assert_row_after_move_right(new_game, 0, "2222", "0044")
    assert_row_after_move_right(new_game, 0, "4022", "0044")
    assert_row_after_move_right(new_game, 0, "2202", "0024")
  end

  def new_game
    Game.new(Board.new(4))
  end

  def test_game_move_left
    assert_row_after_move_left(new_game, 0, "2000", "2000")
    assert_row_after_move_left(new_game, 0, "0200", "2000")

    assert_row_after_move_left(new_game, 0, "0202", "4000")
    assert_row_after_move_left(new_game, 0, "2002", "4000")
    assert_row_after_move_left(new_game, 0, "2020", "4000")
    assert_row_after_move_left(new_game, 0, "2200", "4000")

    assert_row_after_move_left(new_game, 0, "2022", "4200")
    assert_row_after_move_left(new_game, 0, "2000", "2000")
    assert_row_after_move_left(new_game, 0, "2222", "4400")
    assert_row_after_move_left(new_game, 0, "4022", "4400")
  end

  def test_left_right
    g = new_game
    g.board.set_row(0, "4022")
    g.play_left
    g.play_right
    assert_row(g.board, 0, "0008")
  end

  def test_right_left
    g = new_game
    g.board.set_row(0, "4022")
    g.play_right
    g.play_left
    assert_row(g.board, 0, "8000")
  end

  def test_two_rows
    g = new_game
    g.board.set_row(0, "4022")
    g.board.set_row(1, "4022")
    g.play_right
    g.play_left
    assert_row(g.board, 0, "8000")
    assert_row(g.board, 1, "8000")
  end

  def test_whole_board
    g = new_game
    g.board.set_row(0, "4022")
    g.board.set_row(1, "4022")
    g.board.set_row(2, "4022")
    g.board.set_row(3, "4022")
    g.play_right
    g.play_left
    assert_board(g,["8000",
                    "8000",
                    "8000",
                    "8000"])
    #g.play_down
  end

  def assert_board(g, rows)
    rows.each_with_index {|row, i| assert_row(g.board, i, row)}
  end

  def assert_row(board, row, values)
    assert_equal(values.scan(/\w/).map{|c| c.to_i}, board.get_row(row))
  end

  def assert_row_after_move_right(game, row, before, after)
    game.board.set_row(row, before)
    game.play_right
    assert_row(game.board, row, after)
  end

  def assert_row_after_move_left(game, row, before, after)
    game.board.set_row(row, before)
    game.play_left
    assert_row(game.board, row, after)
  end
end
