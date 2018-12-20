require 'lib'

module ActiveJson
  class Error < StandardError; end

  def self.call(json, filters)
    data = JSON.parse(json, symbolize_names: true)
    filters = filters.each { |attributes| Filter.new(attributes)}
    Query.execute(data, where: filters)
  end

end
