require 'spec_helper'
require 'json'

RSpec.describe ActiveJson::Pluck do

  let(:pluck) { ActiveJson::Pluck.new(attribute) }
  let(:hash) do
    { type: 'mountain', attributes: { height: '3000m', prominance: '2000m' } }
  end

  subject(:plucked_result) { pluck.call(hash) }

  context 'top level attribute' do
    let(:attribute) { 'type' }
    it { expect(plucked_result).to eq 'mountain' }
  end

  context 'nested attribute' do
    let(:attribute) { 'attributes.height' }
    it { expect(plucked_result).to eq '3000m' }
  end

  context 'missing attribute' do
    let(:attribute) { 'color' }
    it { expect(plucked_result).to eq nil }
  end

  context 'missing nested attribute' do
    let(:attribute) { 'color.favorite' }
    it { expect(plucked_result).to eq nil }
  end

  context 'nil attribute' do
    let(:attribute) { nil }
    it { expect(plucked_result).to eq hash }
  end
end
