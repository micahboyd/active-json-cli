require 'spec_helper'

RSpec.describe ActiveJson::Query do

  subject(:query) { ActiveJson::Query }

  let(:select_result) { query.select(data, where: filters) }
  let(:reject_result) { query.reject(data, where: filters) }

  Filter = Struct.new(:attrs) { def call(d); d.send(*attrs); end }

  let(:data)    { (1..10) }
  let(:filters) { [filter1, filter2] }
  let(:filter1) { Filter.new([:<, 9]) }
  let(:filter2) { Filter.new([:>, 5]) }

  context 'selecting data' do
    it { expect(select_result).to eq [6, 7, 8] }
  end

  context 'rejecting data' do
    it { expect(reject_result).to eq [1, 2, 3, 4, 5, 9, 10] }
  end

  context 'with no filters' do
    let(:filters) { [] }
    it { expect(select_result).to eq [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] }
  end

end
