require "lsh/version"

module Lsh
  class << self
    @@k = 5
    def k=(k)
      @@k = k
    end

    def unary(query, c=4)
      _unary = []
      query.each do |i|
        i.times { _unary << 1 }
        (c - i).times { _unary << 0 }
      end
      _unary
    end

    def random_index(length)
      @@random_index ||= begin
        @@random_index = []
        indexs = [*0...length]
        @@k.times { @@random_index << indexs.shuffle!.pop }
        @@random_index
      end
    end
  end
end
