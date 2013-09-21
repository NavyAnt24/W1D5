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


a = ([[" "]*8]*8).deep_dup
a[3][5] = "A"

#module silly_shit(key_elem)
  def deep_include?(key_elem)
    includes = false
    self.each do |elem|
      if elem.instance_of?(Array)
        original_method = self.method(:deep_include?).unbind
        #class <<elem
          #original_method.bind(self)
          # def deep_include?(key_elem, original_method)
 #            original_method.bind(self).call(key_elem)
 #          end
        #end
        p elem
        elem.define_singleton_method(:deep_include?) do |*args, &blk|
          original_method.bind(self).call(*args, &blk)
          #original_method.call(*args)
        end
        #original_method.bind(elem)
        # def elem.deep_include?(el)
#           deep.call(el)
        # end
        includes = includes || elem.deep_include?(key_elem)
      else
        includes = includes || elem == key_elem
      end
    end
    includes
  end
  #end

$deep_inc = method(:deep_include?).unbind

class <<a
  def deep_include?(key_elem)
    $deep_inc.bind(self).call(key_elem)
  end
end

p a
p a.deep_include?("A")