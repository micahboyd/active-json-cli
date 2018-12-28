require 'active_json/filter'

module ActiveJson
  module Query
    extend self

    %i[select reject].each do |query|
      define_method query do |data, where:|
        data.send(query) do |record|
          where.all? { |filter| filter.call(record) }
        end
      end
    end

  end
end
