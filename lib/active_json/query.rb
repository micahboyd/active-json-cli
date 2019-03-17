require 'active_json/filter'

module ActiveJson
  module Query
    extend self

    def select(data, where:, pluck: nil)
      result = array(data).select(&apply_filters(where))
      pluck ? result.map(&pluck_attributes(pluck)).compact : result
    end

    def reject(data, where:, pluck: nil)
      result = array(data).reject(&apply_filters(where))
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

    def array(elem)
      elem.is_a?(Array) ? elem : [elem]
    end

  end
end
