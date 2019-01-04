require 'lib'
require 'json'

module ActiveJson
  class << self

    def select(json, where:, pluck: nil)
      data = parse_json(json)
      filter, pluck = build_query(where, pluck)
      Query.select(data, where: filter, pluck: pluck)
    end

    def reject(json, where:, pluck: nil)
      data = parse_json(json)
      filter, pluck = build_query(where, pluck)
      Query.reject(data, where: filter, pluck: pluck)
    end

    private

    def build_query(where, pluck)
      [
        where.split(',').map { |attrs| Filter.new(attrs.strip) },
        Pluck.new(pluck)
      ]
    end

    def parse_json(json)
      JSON.parse(json, symbolize_names: true)
    end
  end


end
