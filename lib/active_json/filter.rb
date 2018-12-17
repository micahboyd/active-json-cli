module ActiveJson
  module Filter

    VALID_OPERATORS = %i[== != <= >= < >]

    def self.new(args)
      filter = args.split.each.with_object([:[]]) do |a, obj|
        if a['.']
          elem = a.split('.').map.with_index { |e, i| i > 0 ? '.' << e : e }
          elem.each { |e| obj << parse_value(e)}
        else
          obj << parse_value(a)
        end
      end

      keys, pairs = filter.partition { |f| f.is_a?(Array) }
      pairs = pairs.each_slice(2).to_a
      parsed_filter = pairs.insert(1, *keys)

      -> (data) { parsed_filter.reduce(data) { |d, f| d.send(*f) } }
    end

    def self.parse_value(value)
      if value['"'] || value["'"]
        value.delete('"').delete("'")
      elsif value.to_i.to_s == value
        value.to_i
      elsif value['.']
        [value.delete('.').to_sym]
      else
        value.to_sym
      end
    end

  end

end
