require_relative "../reversi"

describe "Reversi" do

  describe "Board" do
    subject(:board) { Board.new }
    # it { should respond_to(:print, :place, :grid, :is_occupied?, :full?) }

    it "should have starting pieces" do
      grid = board.grid
      grid[3][3].should eql "W"
      grid[3][4].should eql "B"
      grid[4][3].should eql "B"
      grid[4][4].should eql "W"
    end

    it "should not be full" do
      board.full?.should eql false
    end

    it "should should respond to #is_occupied? correctly" do
      board.is_occupied?([3,3]).should eql true
      board.is_occupied?([0,0]).should eql false
    end
  end

  describe "Piece" do
  end
end
