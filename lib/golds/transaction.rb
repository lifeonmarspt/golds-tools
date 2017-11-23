module Golds
  class Transaction
    attr_reader :date, :description, :entity, :movements, :metadata

    def initialize date:, description:, entity:, movements:, metadata:
      @date = date
      @description = description
      @entity = entity
      @movements = movements
      @metadata = metadata

      valid? or throw self
    end

    def valid?
      movements.map(&:amount).reduce(&:+).zero?
    end

    def currencies
      movements.flat_map(&:currencies).uniq
    end

    def accounts
      movements.map(&:account).uniq
    end
  end
end
