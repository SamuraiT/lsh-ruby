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
      indexs = Lsh::random_index(Lsh::unary(query).length)
      expect(indexs).to eq(indexs)
    end

    it "returns random index"do
      Lsh::k = k
      expect(Lsh::random_index(Lsh::unary(query).length).length).to eq(k)
    end
  end
end
