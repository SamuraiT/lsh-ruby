require "lsh/version"

module Lsh
  class << self
    attr_accessor :random_index
    attr_accessor :k, :c
    @k = 5
    @c = 4


    def unary(query, _c=nil)
      @c = _c if _c
      _unary = []
      query.each do |i|
        i.times { _unary << 1 }
        (@c - i).times { _unary << 0 }
      end
      _unary
    end

    def make_random_index(length)
      @random_index ||= begin
        @random_index = []
        indexs = [*0...length]
        @k.times { @random_index << indexs.shuffle!.pop }
        @random_index
      end
    end

    def hash(unaried_query)
      make_random_index(unaried_query.length) unless random_index
      random_index.map{ |i| unaried_query[i] }
    end

    def hamming_distance(p,q)
      distance = 0
      xor(p,q).each_char do |bit|
        distance += 1 if bit == "1"
      end
      distance
    end

    def xor(p,q)
      p = p.join('').to_i(2)
      q = q.join('').to_i(2)
      (p ^ q).to_s(2)
    end
  end
end
