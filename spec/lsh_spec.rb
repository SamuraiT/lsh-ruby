require 'spec_helper'

describe Lsh do
  let(:query) { [1, 2, 4] }
  let(:c) { 4 }
  let(:l) { 4 }
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
      indexs = Lsh::make_random_index(Lsh::unary(query).length)
      expect(indexs).to eq(indexs) #just wanted to see it works or not
    end

    it "returns random index"do
      Lsh::k = k
      expect(Lsh::make_random_index(Lsh::unary(query).length).length).to eq(k)
    end

    context "when k=3 and random_indexe=[1,2]" do
      it "raise ConstrainError" do
        Lsh::k = 3
        expect{ Lsh::random_index = [1,2] }.to raise_error(ConstrainError)
      end
    end
  end

  describe "Lsh#hash" do
    let(:c) { 4 }
    let(:q) { [1, 2, 4] }
    let(:random_index) { [2,4,8,11] }

    context "when c=4, q=[1, 2, 4], random-indexes=[2,4,8,11]" do
      it do
        Lsh::k = 4
        Lsh::random_index = random_index
        unaried_query = Lsh::unary(q, c)
        expect(Lsh::hash(unaried_query)).to eq([0,1,1,1])
      end

      it do
        unaried_query = Lsh::unary(q, c)
        expect(Lsh::hash(unaried_query, random_index)).to eq([0,1,1,1])
      end
    end
  end

  describe 'Lsh#hash_l' do
    let(:random_indexes) { [[2,4,8,11], [9,4,7,10], [0,2,9,5], [3,6,2,4]] }
    context "with random_indexes=[[2,4,8,11], [9,4,7,10], [0,2,9,5], [3,6,2,4]]" do
      it do
        Lsh::parameter({c: 4, k: 4, l: 4})
        Lsh::random_indexes = random_indexes
        unaried_query = Lsh::unary(query)
        expect(Lsh::hash_l(unaried_query)).to eq(
          [[0,1,1,1], [1,1,0,1], [1,0,1,1], [0,0,0,1]]
        )
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
        Lsh::random_index = [2,4,8,11]
        p = Lsh::unary(p, Lsh::c)
        q = Lsh::unary(q, Lsh::c)
        expect(Lsh::hamming_distance(p,q)).to eq(2)
      end
    end
  end

  describe 'Lsh#make_random_indexes' do
    it "is array of random_index" do
      indexs = Lsh::make_random_indexes(10, 4)
      indexs.each do |element|
        expect(element).to be_a(Array)
      end
    end

    context "with l=3 and random_indexes=[[4,5,6,7]]" do
      it "raise ConstrainError" do
        Lsh::l = 3
        expect{
          Lsh::random_indexes = [[4,5,6,7]]
        }.to raise_error(ConstrainError)
      end
    end
  end

  describe 'Lsh#parameter' do
    context "when add parameter" do
      it "matches parameter" do
        parameter = {k: 2, c: 4, l: 4}
        Lsh::parameter(parameter)
        expect(Lsh::k).to eq(parameter[:k])
        expect(Lsh::c).to eq(parameter[:c])
        expect(Lsh::l).to eq(parameter[:l])
      end
    end
  end

  describe 'Lsh#store2bucket' do
    let(:random_indexes) { [[2,4,8,11], [9,4,7,10], [0,2,9,5], [3,6,2,4]] }
    it "stores hash" do
      Lsh::parameter({c: 4, k: 4, l: 4})
      Lsh::random_indexes = random_indexes
      Lsh::store2bucket(query)
      expect(Lsh::bucket).to eq(
        {"0111"=>[[1, 2, 4]],
         "1101"=>[[1, 2, 4]],
         "1011"=>[[1, 2, 4]],
         "0001"=>[[1, 2, 4]]
      })
    end
  end

  describe 'Lsh#search' do
    let(:random_indexes) { [[2,4,8,11], [9,4,7,10], [0,2,9,5], [3,6,2,4]] }
    it "search query" do
      Lsh::parameter({c: 4, k:4, l:4})
      Lsh::random_indexes = random_indexes
      querys = [[1,2,4], [1,3,2], [0,2,4], [3,4,1], [2,5,3], [2,2,1]]
      querys.each do |q| Lsh::store2bucket(q) end
      expect(Lsh::search([1,1,3])[:query].last).to eq([1,2,4])
    end
  end
end
