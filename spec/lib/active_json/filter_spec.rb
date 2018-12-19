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

    context 'deeply nested' do
      let(:hash) do
        { clothing: { pant: { size: { waist: 10, style: 'narrow' } } } }
      end
      let(:attributes) { 'clothing.pant.size.waist == 10' }
      it { expect(result).to eq true }
    end
  end

  context 'comparing attributes' do

    context 'top level' do
      let(:hash) { { width: 5, length: 4 } }
      let(:attributes) { 'width > length' }
      it { expect(result).to eq true }
    end

    context 'one nested' do
      let(:hash) { { height: { hat: 5, pant: 2 }, brim: 4 } }
      let(:attributes) { 'height.pant == brim' }
      it { expect(result).to eq false }
    end

    context 'both nested' do
      let(:hash) { { width: { cm: 5, in: 2 }, length: { cm: 4, in: 1 } } }
      let(:attributes) { 'width.cm < length.cm' }
      it { expect(result).to eq false }
    end
  end

end
