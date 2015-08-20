module ListToColumns
  # Columnar list that is column major order; that is the order is
  # top->bottom, then right->left.
  class ColumnMajor
    attr_reader :width, :space

    def initialize(list = nil, options = nil)
      options ||= {}
      @width    = options[:width] || 78
      @space    = options[:space] || 2
      @strings  = Array(list).map(&:to_s)
      return if @strings.empty?

      # Pad out list so it is rectangular.
      @strings[number_of_columns * number_of_rows - 1] ||= nil
    end

    def longest_string_length
      @longest_string_length ||= @strings.map(&:length).max || 0
    end

    def number_of_columns
      return 0 if @strings.empty?
      @number_of_columns ||= (width + space) / (longest_string_length + space)
    end

    def number_of_rows
      return 0 if @strings.empty?
      @number_of_rows ||= (@strings.length.to_f / number_of_columns).ceil
    end

    def matrix
      @matrix ||= @strings
        .each_slice(number_of_rows)
        .to_a
        .transpose
        .map(&:compact)
        .map(&:freeze)
        .freeze
    end

    def to_s
      matrix
        .map { |r| r.map { |s| pad s }.join(' ' * space) }
        .map(&:rstrip)
        .join("\n")
    end

    private

    def pad(string)
      format "%-#{longest_string_length}s", string
    end
  end
end