require 'spec_helper'
require 'json'

RSpec.describe ActiveJson::Filter do

  subject(:filter) { ActiveJson::Filter.new(attributes) }

  let(:data)       { { key: 'value' } }
  let(:attributes) { "key == 'value'" }
  let(:result)     { filter.call(data) }

  it { expect(filter).to be_instance_of Proc }
  it { expect(result).to eq true }

  describe 'comparing String values' do
    let(:data) { { user: 'coach' } }

    context '==' do
      let(:attributes) { 'user == "coach"' }
      it { expect(result).to eq true }
    end

    context '!=' do
      let(:attributes) { "user != 'coach'" }
      it { expect(result).to eq false }
    end

    describe 'with spaces' do
      let(:data) { { user: 'coach man' } }

      context '==' do
        let(:attributes) { 'user == "coach man"' }
        it { expect(result).to eq true }
      end

      context '!=' do
        let(:attributes) { "user != 'coach man'" }
        it { expect(result).to eq false }
      end
    end
  end

  [['Integer', 5],['Float', 5.5]].each do |type, value|
    describe "comparing #{type} values" do
      let(:data) { { size: value } }

      context '==' do
        let(:attributes) { "size == #{value}" }
        it { expect(result).to eq true }
      end

      context '!=' do
        let(:attributes) { "size != #{value}" }
        it { expect(result).to eq false }
      end

      context '>' do
        let(:attributes) { "size > #{value}" }
        it { expect(result).to eq false }
      end

      context '>=' do
        let(:attributes) { "size >= #{value}" }
        it { expect(result).to eq true }
      end

      context '<' do
        let(:attributes) { "size < #{value}" }
        it { expect(result).to eq false }
      end

      context '<=' do
        let(:attributes) { "size <= #{value}" }
        it { expect(result).to eq true }
      end
    end
  end

  describe 'comparing nested values' do
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

  describe 'comparing attributes' do

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

  describe 'comparing missing' do

    context 'attribute' do
      let(:data) { { length: 4 } }
      let(:attributes) { 'width > 5' }
      it { expect(result).to eq nil }
    end

    context 'value' do
      let(:data) { { width: 5, length: 4 } }
      let(:attributes) { 'width > height' }
      it { expect(result).to eq nil }
    end

    context 'nested attribute' do
      let(:data) { { height: { hat: 5, pant: 2 }, brim: 4 } }
      let(:attributes) { 'height.sleeve == 2' }
      it { expect(result).to eq nil }
    end

    context 'nested value' do
      let(:data) { { width: { cm: 5, in: 2 }, length: { cm: 4, in: 1 } } }
      let(:attributes) { 'width.cm < length.mm' }
      it { expect(result).to eq nil }
    end
  end

end
