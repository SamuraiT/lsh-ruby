require "lsh/version"
require 'lsh/error'

module Lsh
  class << self
    attr_accessor :random_index, :random_indexes
    attr_accessor :k, :c, :l
    @k = 5
    @c = 4
    @l = 4

    def parameter(params={})
      @k = params[:k] if params[:k]
      @c = params[:c] if params[:c]
      @l = params[:l] if params[:l]
      "<Lsh::parameter  k:#{@k}, c:#{@c}, l:#{@l}>"
    end

    def unary(query, _c=nil)
      @c = _c if _c
      _unary = []
      query.each do |i|
        i.times { _unary << 1 }
        (@c - i).times { _unary << 0 }
      end
      _unary
    end

    def random_index=(random_index)
      @random_index = random_index
      check_constaint(@random_index, @k)
    end

    def random_indexes=(random_indexes)
      @random_indexes = random_indexes
      check_constaint(@random_indexes, @l)
    end

    def make_random_index(length)
      @random_index ||= begin
        @random_index = []
        indexs = [*0...length]
        @k.times { @random_index << indexs.shuffle!.pop }
        @random_index
      end
      check_constaint(@random_index, @k)
    end

    def make_random_indexes(length, l=nil)
      @l = l if l
      @random_indexes ||= begin
        indexes = []
        @l.times { indexes << make_random_index(length) }
        indexes
      end
      check_constaint(@random_indexes, @l)
    end

    def hash(unaried_query, random_index=nil)
      random_index = make_random_index(unaried_query.length) if random_index.nil?
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

    def hash_l(unaried_query)
      make_random_indexes(unaried_query.length)
      @random_indexes.map do |random_index|
        hash(unaried_query, random_index)
      end
    end

    private
    def check_constaint(target, expected)
      if target.length == expected
        target
      else
        raise ConstrainError
      end
    end
  end
end
