require "lsh/version"

module Lsh
  class << self

    def unary(q, c)
      _unary = []
      q.each do |i|
        i.times { _unary << 1 }
        (c - i).times { _unary << 0 }
      end
      _unary
    end
  end
end
