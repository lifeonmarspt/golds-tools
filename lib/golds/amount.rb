module Golds
  class Amount
    def self.zero
      self.new
    end

    def initialize data={}
      @data = data
    end

    def +(amount)
      self.class.new(
        [self, amount].
          flat_map(&:currencies).
          uniq.
          map { |currency| [currency, value(currency) + amount.value(currency)] }.
          to_h
      )
    end

    def zero?
      data.values.all? { |v| v.zero? }
    end

    def -@
      self.class.new data.transform_values(&:-@)
    end

    def currencies
      data.keys
    end

    def value currency
      data.fetch currency, 0
    end

    def to_s
      data.
        entries.
        sort_by(&:first).
        map { |(currency, amount)| "#{"%.2f" % amount} #{currency}" }.
        join("\t")
    end

    private
    attr_reader :data
  end
end
