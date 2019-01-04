module ActiveJson
  module Pluck
    extend self

    def new(pluck)
      attributes = split_nested(pluck)
      -> (hash) do
        attributes ? attributes.reduce(hash, &dig_attribute) : hash
      end
    end

    def dig_attribute
      -> (hash, attribute) { hash.dig(attribute) if hash }
    end

    def split_nested(pluck)
      return unless pluck
      pluck.split('.').map(&:to_sym)
    end

  end
end
