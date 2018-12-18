module ActiveJson
  module Filter

    VALID_OPERATORS = %i[== != <= >= < >]

    def self.new(args)
      filter = args.split.each.with_object([:[]]) do |a, obj|
        obj.append(*parse_value(a))
      end

      paired_filter = filter.each_slice(2).to_a
      filter_lambda(paired_filter)
    end

    def self.parse_value(value)
      if value['"'] || value["'"]
        value.delete('"').delete("'")
      elsif value.to_i.to_s == value
        value.to_i
      elsif value['.']
        value.gsub('.', ' [] ').split.map(&:to_sym)
      else
        value.to_sym
      end
    end

    def self.filter_lambda(filter)
      -> (data) do
        filter.reduce(data) { |d, pair| d.send(*pair) }
      end
    end

  end

end
