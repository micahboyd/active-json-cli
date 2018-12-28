RSpec.describe ActiveJson do

  subject(:active_json) { ActiveJson.select(json, query: filters) }

  let(:json)    { IO.read(file) }
  let(:filters) { 'drink_name == "latte"' }
  let(:file)    { 'spec/data/prices.json' }

  it 'has a version number' do
    expect(ActiveJson::VERSION).not_to be nil
  end

  context 'Selects JSON' do
    it do
      expect(active_json).to eq(
        [
          { drink_name: 'latte',
            prices: { small: 3.5, medium: 4.0, large: 4.5 } }
        ]
      )
    end
  end

  context 'Selects JSON' do
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
