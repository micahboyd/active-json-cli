module ActiveJson
  module Filter
    extend self

    VALID_OPERATORS = %w[== != <= >= < >].freeze

    def new(args)
      attributes = args.split.map(&parse_value)
      filter_lambda(attributes)
    end

    private

    def filter_lambda(filter)
      -> (data) do
        extracted_data, *operation = filter.clone.map! do |attribute|
          attribute.is_a?(Array) ? reduce_data(attribute, data) : attribute
        end
        extracted_data.send(*operation)
      end
    end

    # --------- HELPERS ---------

    def parse_value
      -> (value) do
        case value
        when string   then value[1..-2]
        when float    then value.to_f
        when integer  then value.to_i
        when operator then value.to_sym
        when chain    then parse_chain(value)
        else [[:[], value.to_sym]]
        end
      end
    end

    def string
      -> (value) { %w[' "].any? { |q| value.start_with?(q) && value.end_with?(q) } }
    end

    def float
      -> (value) { value.to_f.to_s == value }
    end

    def integer
      -> (value) { value.to_i.to_s == value }
    end

    def operator
      -> (value) { VALID_OPERATORS.include?(value) }
    end

    def chain
      -> (value) { value['.'] }
    end

    def parse_chain(value)
      value.gsub('.', ' [] ')
           .split
           .prepend(:[])
           .map(&:to_sym)
           .each_slice(2)
           .to_a
    end

    def reduce_data(pairs, data)
      pairs.reduce(data) { |d, pair| d.send(*pair) }
    end

  end
end
