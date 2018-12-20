require 'spec_helper'
require 'json'

RSpec.describe ActiveJson::Filter do

  subject(:filter) { ActiveJson::Filter.new(attributes) }

  let(:data)       { { key: 'value' } }
  let(:attributes) { "key == 'value'" }
  let(:result)     { filter.call(data) }

  it { expect(filter).to be_instance_of Proc }
  it { expect(result).to eq true }

  context 'comparing String values' do
    let(:data) { { user: 'coach' } }

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
    let(:data) { { size: 5 } }

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
    let(:data) { { size: { waist: 10, style: 'narrow' } } }

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
      let(:data) do
        { clothing: { pant: { size: { waist: 10, style: 'narrow' } } } }
      end
      let(:attributes) { 'clothing.pant.size.waist == 10' }
      it { expect(result).to eq true }
    end
  end

  context 'comparing attributes' do

    context 'top level' do
      let(:data) { { width: 5, length: 4 } }
      let(:attributes) { 'width > length' }
      it { expect(result).to eq true }
    end

    context 'one nested' do
      let(:data) { { height: { hat: 5, pant: 2 }, brim: 4 } }
      let(:attributes) { 'height.pant == brim' }
      it { expect(result).to eq false }
    end

    context 'both nested' do
      let(:data) { { width: { cm: 5, in: 2 }, length: { cm: 4, in: 1 } } }
      let(:attributes) { 'width.cm < length.cm' }
      it { expect(result).to eq false }
    end
  end

end
