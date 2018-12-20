module ActiveJson
  module Query

    def self.execute(data, where: [])
      data.select do |record|
        where.all? { |filter| filter.call(record) }
      end
    end

  end
end
