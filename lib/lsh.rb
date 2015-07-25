require "lsh/version"

module Lsh
  class << self
    attr_accessor :random_indexes
    attr_accessor :k
    @k = 5

    def unary(query, c=4)
      _unary = []
      query.each do |i|
        i.times { _unary << 1 }
        (c - i).times { _unary << 0 }
      end
      _unary
    end

    def make_random_indexes(length)
      @random_indexes ||= begin
        @random_indexes = []
        indexs = [*0...length]
        @k.times { @random_indexes << indexs.shuffle!.pop }
        @random_indexes
      end
    end
  end
end
