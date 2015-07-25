require 'spec_helper'

describe Lsh do
  let(:query) { [1, 2, 4] }
  let(:c) { 4 }
  let(:k) { 5 }

  it 'has a version number' do
    expect(Lsh::VERSION).not_to be nil
  end

  describe 'Lsh#unary' do
    it "turns query as binary vector" do
      expect(Lsh::unary(query, c)).to eq([1,0,0,0,1,1,0,0,1,1,1,1])
    end
  end

  describe 'Lsh#random_index' do
    it do
      Lsh::k = k
      indexs = Lsh::make_random_indexes(Lsh::unary(query).length)
      expect(indexs).to eq(indexs)
    end

    it "returns random index"do
      Lsh::k = k
      expect(Lsh::make_random_indexes(Lsh::unary(query).length).length).to eq(k)
    end
  end

  describe "Lsh#hash" do
    context "when c=4, q=[1, 2, 4], random-indexes=[2,4,8,11]" do
      it do
        c = 4
        q=[1, 2, 4]
        Lsh::random_indexes = [2,4,8,11]
        expect(Lsh::hash(Lsh::unary(q, c))).to eq([0,1,1,1])
      end
    end
  end

  describe "Lsh#hamming_distance" do
    context "when p=[1,0,3], q=[2,0,2] c=3, k=4, random-indexes=[2,4,8,11]" do
      it  do
        Lsh::c = 3
        Lsh::k = 4
        p = [1,0,3]
        q = [2,0,2]
        Lsh::random_indexes = [2,4,8,11]
        p = Lsh::unary(p, Lsh::c)
        q = Lsh::unary(q, Lsh::c)
        expect(Lsh::hamming_distance(p,q)).to eq(2)
      end
    end
  end
end
