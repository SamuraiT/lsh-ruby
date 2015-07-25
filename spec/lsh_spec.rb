require 'spec_helper'

describe Lsh do
  it 'has a version number' do
    expect(Lsh::VERSION).not_to be nil
  end

  describe 'Lsh#unary' do
    it "turns query as binary vector" do
      q = [1, 2, 4]
      c = 4
      expect(Lsh::unary(q, c)).to eq([1,0,0,0,1,1,0,0,1,1,1,1])
    end
  end
end
