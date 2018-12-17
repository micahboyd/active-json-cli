require 'spec_helper'
require 'ostruct'
require 'json'

RSpec.describe ActiveJson::Filter do

  subject(:filter) { ActiveJson::Filter.new(attributes) }

  let(:data)       { JSON.parse(hash.to_json, object_class: OpenStruct) }
  let(:hash)       { { key: 'value' } }
  let(:attributes) { "key == 'value'" }
  let(:result)     { filter.call(data) }

  it { expect(filter).to be_instance_of Proc }
  it { expect(result).to eq true }

  context 'comparing String values' do
    let(:hash) { { user: 'coach' } }

    context '==' do
      let(:attributes) { 'user == "coach"' }
      it { expect(result).to eq true }
    end

    context '!=' do
      let(:attributes) { "user != 'coach'" }
      it { expect(result).to eq false }
    end
  end

  context 'comparing Integer values' do
    let(:hash) { { size: 5 } }

    context '==' do
      let(:attributes) { 'size == 5' }
      it { expect(result).to eq true }
    end

    context '!=' do
      let(:attributes) { 'size != 5' }
      it { expect(result).to eq false }
    end

    context '>' do
      let(:attributes) { 'size > 5' }
      it { expect(result).to eq false }
    end

    context '>=' do
      let(:attributes) { 'size >= 5' }
      it { expect(result).to eq true }
    end

    context '<' do
      let(:attributes) { 'size < 5' }
      it { expect(result).to eq false }
    end

    context '<=' do
      let(:attributes) { 'size <= 5' }
      it { expect(result).to eq true }
    end
  end

  context 'comparing nested values' do
    let(:hash) { { size: { waist: 10, style: 'narrow' } } }

    context '==' do
      let(:attributes) { 'size.style == "narrow"' }
      it { expect(result).to eq true }
    end

    context '!=' do
      let(:attributes) { 'size.style != "XL"' }
      it { expect(result).to eq true }
    end

    context '>' do
      let(:attributes) { 'size.waist > 10' }
      it { expect(result).to eq false }
    end

    context '>=' do
      let(:attributes) { 'size.waist >= 10' }
      it { expect(result).to eq true }
    end

    context '<' do
      let(:attributes) { 'size.waist < 5' }
      it { expect(result).to eq false }
    end

    context '<=' do
      let(:attributes) { 'size.waist <= 5' }
      it { expect(result).to eq false }
    end
  end

end
