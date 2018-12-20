require 'spec_helper'

RSpec.describe ActiveJson::Query do

  subject(:query_result) { ActiveJson::Query.execute(data, where: filters) }

  let(:data)    { (1..10) }
  let(:filters) { [filter1, filter2] }
  Filter = Struct.new(:method) { def call(d); d.send(*method); end }

  context 'context' do
    let(:filter1) { Filter.new([:<, 9]) }
    let(:filter2) { Filter.new([:>, 5]) }
    it 'does something' do
      expect(query_result).to eq [6, 7, 8]
    end
  end

end
