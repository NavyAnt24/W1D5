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

  def deep_include?(key_elem)
    includes = false
    self.each do |elem|
      if elem.instance_of?(Array)
        includes = includes || elem.deep_include?(key_elem)
      else
        includes = includes || elem == key_elem
      end
    end
    includes
  end
end

class Board
  E = " "
  W = "W"
  B = "B"

  attr_reader :grid

  def initialize
    @grid = ([[E]*8]*8).deep_dup
    @grid[3][3],@grid[4][4] = W,W
    @grid[3][4],@grid[4][3] = B,B
  end

  def full?
    !@grid.deep_include?(E)
  end

  def is_occupied?(vertex)
    @grid[vertex[0]][vertex[1]] != E
  end
end