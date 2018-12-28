require 'lib'
require 'json'

module ActiveJson
  class << self

    def select(json, query:)
      data = parse_json(json)
      filters = build_filters(query)
      Query.select(data, where: filters)
    end

    def reject(json, query:)
      data = parse_json(json)
      filters = build_filters(query)
      Query.reject(data, where: filters)
    end

    private

    def build_filters(query)
      query.split(',').map { |attrs| Filter.new(attrs.strip) }
    end

    def parse_json(json)
      JSON.parse(json, symbolize_names: true)
    end
  end


end
