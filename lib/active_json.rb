require 'lib'
require 'json'

module ActiveJson
  class << self

    def select(json, where:)
      data = parse_json(json)
      filters = build_filters(where)
      Query.select(data, where: filters)
    end

    def reject(json, where:)
      data = parse_json(json)
      filters = build_filters(where)
      Query.reject(data, where: filters)
    end

    private

    def build_filters(where)
      where.split(',').map { |attrs| Filter.new(attrs.strip) }
    end

    def parse_json(json)
      JSON.parse(json, symbolize_names: true)
    end
  end


end
