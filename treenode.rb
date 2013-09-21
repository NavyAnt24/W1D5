class TreeNode
  attr_accessor :parent, :value, :left_child, :right_child

  def initialize(parent, value)
    @parent = parent
    @value = value
  end

  def set_child(node, val)
    case @value <=> val
    when -1
      @right_child = node
    when 1
      @left_child = node
    end
  end

  def dfs(val)
    return self if val == @value
    child = which_child(val)
    if child.nil?
      return nil
    end
    return child.dfs(val)
  end

  def bfs(val)
    nodes = [self]
    until nodes.empty?
      current = nodes.shift
      next if current.nil?
      return current if current.value == val
      nodes += [current.left_child, current.right_child]
    end
    nil
  end

  def which_child(val)
    case @value <=> val
    when -1
      @right_child
    when 1
      @left_child
    end
  end

  def add_node(val)
    which_child = which_child(val)
    if which_child.nil?
      set_child(TreeNode.new(self, val), val)
      return
    end
    return if which_child.value == val
    which_child.add_node(val)
  end
end

root = TreeNode.new(nil, 25)
(0..50).to_a.shuffle.each do |value|
  root.add_node(value)
end

p root.dfs(5).value
p root.bfs(5).value