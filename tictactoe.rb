def mutable?(object)
  if object.is_a?(Fixnum)
    return false
  elsif object.is_a?(TrueClass)
    return false
  elsif object.is_a?(FalseClass)
    return false
  elsif object.is_a?(NilClass)
    return false
  else
    return true
  end
end

class Array
  def test
    p square(5)
  end

  def deep_dup
    duped_array = []
    self.each do |elem|
      if elem.instance_of?(Array)
        duped_array << elem.deep_dup
      elsif mutable?(elem)
        duped_array << elem.dup
      else
        duped_array << elem
      end
    end
    duped_array
  end
end

class Board
  O = "O"
  X = "X"
  E = " "
  attr_accessor :grid

  def initialize(start_grid)
    @grid = start_grid
  end

  def print
    puts "\#\#\#\#\#\#\#"
    puts "\##{@grid[0][0]}|#{@grid[0][1]}|#{@grid[0][2]}\#"
    puts "\#-----\#"
    puts "\##{@grid[1][0]}|#{@grid[1][1]}|#{@grid[1][2]}\#"
    puts "\#-----\#"
    puts "\##{@grid[2][0]}|#{@grid[2][1]}|#{@grid[2][2]}\#"
    puts "\#\#\#\#\#\#\#"
    puts ""
  end

  def set(row, column, team)
    @grid[row][column] = team
  end

  def occupied?(row, column)
    return false if @grid[row][column] == E
    return true
  end

  #really ugly needs refactoring
  def win?(options = {})
    defaults = {
      silent: false
    }
    options = defaults.merge(options)
    team = E
    0.upto(2) do |index|
      team = X
      break if basic_check(index, team)
      team = O
      break if basic_check(index, team)
      team = E
    end
    if team == E
      won = false
      team = X
      won = true if diagonal_check(team)
      if !won
        team = O
        won = true if diagonal_check(team)
      end
      return false if !won
    end
    puts " #{team} wins!" unless options[:silent]
    return true
  end

  def full?
    @grid.each do |row|
      row.each do |spot|
        if spot == E
          return false
        end
      end
    end
    puts "It's a tie!"
    return true
  end


  def basic_check(index, team)
    win = [team, team, team]
    if @grid[index] == win
      return true
    end
    if [@grid[0][index], @grid[1][index], @grid[2][index]] == win
      return true
    end
    return false
  end

  def diagonal_check(team)
    win = [team, team, team]
    if [@grid[0][0], @grid[1][1], @grid[2][2]] == win
      return true
    end
    if[@grid[0][2], @grid[1][1], @grid[2][0]] == win
      return true
    end
    return false
  end
end

class Player
  O = "O"
  X = "X"
  E = " "

  attr_reader :team

  def initialize(board, team)
    @board = board
    @team = team
  end
end

class HumanPlayer < Player
  def prompt
    while true
      move = []
      puts "Which row would you like to go in?"
      move[0] = gets.chomp.to_i - 1
      puts "Which column would you like to go in?"
      move[1] = gets.chomp.to_i - 1
      if !@board.occupied?(move[0], move[1])
        break
      end
      puts "Invalid location! That spot is occupied"
    end
    move
  end
end

class ComputerPlayer < Player
  def prompt
    @root = TreeNode.new(@board, nil)

    winning_move = winning_move
    return winning_move if winning_move

    block_move = block_move
    return block_move if block_move

    look_ahead = look_ahead
    return look_ahead if look_ahead

    return random_move
  end

  def winning_move
    loop_boards(@board.grid, @team) do |row, column, test_board|
      if test_board.win?({silent: true})
        return [row, column]
      else
        @root.add_child(TreeNode.new(test_board.grid.deep_dup, [row, column]))
      end
    end
    return nil
  end

  def block_move
    loop_boards(@board.grid, opposite_team(@team)) do |row, column, test_board|
      if test_board.win?({silent: true})
        return [row, column]
      end
    end
  end

  def look_ahead
    @root.children.each do |our_move|
      loop_boards(our_move.grid, opposite_team(@team)) do |op_row, op_column, op_test_board|
        winning = true
        loop_boards(op_test_board.grid, @team) do |row, column, test_board|
          winning = false unless test_board.win?({silent: true})
        end
        return our_move.move if winning
      end
    end
    return nil
  end

  def random_move
    size = (0..2).to_a
    move = [size.sample, size.sample]
    while @board.occupied?(move[0], move[1]) #&& !blacklisted_moves.include?(move)
      move = [size.sample, size.sample]
    end

    return move
  end

  def loop_boards(base_board, team)
    test_board = Board.new(base_board)
    0.upto(2) do |row|
      0.upto(2) do |column|
        if !test_board.occupied?(row, column)
          test_board.set(row, column, team)
          yield(row, column, test_board)
          test_board.set(row, column, E)
        end
      end
    end
  end

  def opposite_team(team)
    return X if team == O
    return O if team == X
  end
end

class TicTacToe
  O = "O"
  X = "X"
  E = " "

  def initialize()
    @board = Board.new([[E,E,E],[E,E,E],[E,E,E]])
  end

  def first_run
    puts "How many players (0 for computer vs. computer)?"
    num_players = gets.chomp.to_i
    p num_players
    case num_players
    when 2
      @player1 = HumanPlayer.new(@board, X)
      @player2 = HumanPlayer.new(@board, O)
    when 1
      @player1 = HumanPlayer.new(@board, X)
      @player2 = ComputerPlayer.new(@board, O)
    else
      @player1 = ComputerPlayer.new(@board, X)
      @player2 = ComputerPlayer.new(@board, O)
    end
  end

  def run
    first_run

    until @board.win? || @board.full?
      self.move(@player1)
      break if @board.win? || @board.full?
      self.move(@player2)
    end
  end

  def move(player)
    move = player.prompt
    @board.set(move[0],move[1],player.team)
    #puts "&&&&&&&&"
    @board.print
  end
end

class TreeNode
  attr_accessor :grid, :children, :move

  def initialize(grid, move)
    @grid = grid
    @children = []
    @move = move
  end

  def add_child(child)
    @children << child
  end
end

game = TicTacToe.new
game.run

#printer([[O,X,O],[X,O,X],[O,O,X]])