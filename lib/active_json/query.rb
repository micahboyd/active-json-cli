require 'active_json/filter'

module ActiveJson
  module Query
    extend self

    def select(data, where:, pluck: nil)
      result = Array(data).select(&apply_filters(where))
      pluck ? result.map(&pluck_attributes(pluck)).compact : result
    end

    def reject(data, where:, pluck: nil)
      result = Array(data).reject(&apply_filters(where))
      pluck ? result.map(&pluck_attributes(pluck)).compact : result
    end

    private

    def apply_filters(filters)
      -> (record) do
        filters.all? { |filter| filter.call(record) }
      end
    end

    def pluck_attributes(pluck)
      -> (record) { pluck.call(record) }
    end

  end
end
