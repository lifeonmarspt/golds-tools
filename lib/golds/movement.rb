module Golds
  class Movement
    attr_reader :account, :amount

    def initialize account:, amount:
      amount.currencies.length == 1 or raise

      @account = account
      @amount = amount
    end

    def currency
      amount.currencies.first
    end

    def value
      amount.value currency
    end
  end
end
