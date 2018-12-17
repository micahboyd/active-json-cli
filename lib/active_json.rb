require 'lib'

module ActiveJson
  class Error < StandardError; end

  def self.call(json, filters)
    data = JSON.parse(json, object_class: OpenStruct)
    filters = fiters.each { |attributes| Filter.new(attributes)}
  end

end
