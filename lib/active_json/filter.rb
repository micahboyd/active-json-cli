module ActiveJson
  module Filter
    extend self

    VALID_OPERATORS = %w[== != <= >= < >].freeze

    def new(args)
      attributes = process_args(args)
      values = attributes.map(&parse_values)
      filter_lambda(values)
    end

    private

    def filter_lambda(filter)
      -> (data) do
        extracted_data, *operation = filter.clone.map! do |attribute|
          attribute.is_a?(Array) ? reduce_data(attribute, data) : attribute
        end
        extracted_data&.send(*operation) unless operation.include?(nil)
      end
    end

    # --------- HELPERS ---------

    def process_args(args)
      string_quote = args['"'] || args["'"]
      if string_quote
        split_with_strings(args, string_quote)
      else
        args.split
      end
    end

    def split_with_strings(args, quote)
      string_start = args.index(quote)
      string_end = args.rindex(quote)
      string = args[string_start..string_end]
      args.split.each.with_index(-1).with_object([]) do |(arg, i), obj|
        string[arg] && string[obj[i]] ? obj[i] << " #{arg}" : obj << arg
      end
    end

    def parse_values
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
