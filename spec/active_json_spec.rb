RSpec.describe ActiveJson::CLI do

  subject(:active_json) { ActiveJson::CLI.select(json, where: filters, pluck: pluck) }

  let(:file)    { 'spec/data/prices.json' }
  let(:json)    { IO.read(file) }
  let(:filters) { 'drink_name == "latte"' }
  let(:pluck)   { nil }

  it 'has a version number' do
    expect(ActiveJson::VERSION).not_to be nil
  end

  describe 'where:' do

    context 'selecting with 1 filter' do
      it do
        expect(active_json).to eq(
          [
            { drink_name: 'latte',
              prices: { small: 3.5, medium: 4.0, large: 4.5 } }
          ]
        )
      end
    end

    context 'selecting 2 filters' do
      let(:filters) { 'prices.small < 3.5, drink_name != "latte"' }
      it do
        expect(active_json).to eq(
          [
            { drink_name: 'short espresso',
              prices: { small: 3.0 } },
            { drink_name: 'long black',
              prices: { small: 3.25, medium: 3.5 } }
          ]
        )
      end
    end

    context 'selecting with 3 filters' do
      let(:filters) { 'drink_name != "short espresso", drink_name != "long black", prices.small <= 3.5' }
      it do
        expect(active_json).to eq(
          [
            { drink_name: 'latte',
              prices: { small: 3.5, medium: 4.0, large: 4.5 } },
            { drink_name: 'flat white',
              prices: { small: 3.5, medium: 4.0, large: 4.5 } }
          ]
        )
      end
    end

    context 'selecting with no filters' do
      let(:filters)   { nil }
      let(:full_data) { JSON.parse(json, symbolize_names: true) }
      it { expect(active_json).to eq full_data }
    end

    context 'selecting with filter value with space' do
      let(:filters) { 'drink_name == "short espresso"' }
      it do
        expect(active_json).to eq(
          [
            { drink_name: 'short espresso',
              prices: { small: 3.0 } }
          ]
        )
      end
    end

    context 'selecting with filter value of float' do
      let(:filters) { 'prices.small == 3.0' }
      it do
        expect(active_json).to eq(
          [
            { drink_name: 'short espresso',
              prices: { small: 3.0 } }
          ]
        )
      end
    end

  end

  describe 'pluck:' do
    let(:filters) { 'prices.small > 0' }

    context 'top level attribute' do
      let(:pluck) { 'drink_name' }
      it { expect(active_json).to eq ['short espresso', 'latte', 'flat white', 'long black', 'mocha'] }
    end

    context 'nested attribute' do
      let(:pluck) { 'prices.small' }
      it { expect(active_json).to eq [3.0, 3.5, 3.5, 3.25, 4.0] }
    end

    context 'missing attribute' do
      let(:pluck) { 'color' }
      it { expect(active_json).to eq [] }
    end

  end

end
