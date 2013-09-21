class TreeNode
  attr_reader :parent, :vertex

  def initialize(parent, vertex)
    @parent = parent
    @vertex = vertex
  end

  def find_path
    path = [self]
    return path if @parent.nil?
    path << @parent.find_path
    path.flatten
  end
end

class KnightPathFinder
  attr_accessor :start_vertex

  def initialize(start_vertex)
    @start_vertex = start_vertex
  end

  def build_move_tree(end_vertex)
    nodes = [TreeNode.new(nil, @start_vertex)]

    run(end_vertex, nodes)

    path = get_node(end_vertex, nodes).find_path
    path.reverse.each { |node| p node.vertex }
  end

  def run(end_vertex, nodes)
    node_index = 0

    until node_exists?(end_vertex, nodes)
      new_moves = new_move_positions(nodes[node_index].vertex)
      new_moves = filter_moves(new_moves)
      new_moves.select { |move| !node_exists?(move, nodes) }
      new_moves.each do |vertex|
        nodes << TreeNode.new(nodes[node_index], vertex)
      end

      node_index += 1
      raise "Out of nodes" if node_index >= nodes.length
    end
  end

  def node_exists?(vertex, nodes)
    nodes.each do |node|
      return true if vertex == node.vertex
    end
    false
  end

  def get_node(vertex, nodes)
    nodes.each do |node|
      return node if vertex == node.vertex
    end
    nil
  end

  def new_move_positions(vertex)
    new_moves = []

    [-2, 2].each do |x|
      [-1, 1].each do |y|
        new_moves << [x,y]
        new_moves << [y,x]
      end
    end

    new_moves.map { |x, y| [vertex[0] + x, vertex[1] + y] }
  end

  def filter_moves(vertices)
    vertices.select do |vertex|
      (0..7).cover?(vertex[0]) && (0..7).cover?(vertex[1])
    end
  end
end

KnightPathFinder.new([0,0]).build_move_tree([3,3])