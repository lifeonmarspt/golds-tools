require_relative 'account_mapper'
require_relative 'ledger'

module Golds
  class MonthlyReport
    def initialize transactions, mapper, account_filter
      @transactions = transactions
      @mapper = mapper
      @account_filter = account_filter
    end

    def amount month, account
      table.dig(month, account) || Golds::Amount.zero
    end

    def table
      @table ||= @transactions.
        group_by { |transaction| start_of_month transaction.date }.
        transform_values do |transactions|
          transactions.
            flat_map(&:movements).
            select { |movement| @account_filter.call(movement.account) }.
            group_by { |movement| @mapper.map movement.account }.
            transform_values do |movements|
              movements.map(&:amount).reduce(&:+)
            end
        end
    end

    def accounts
      @accounts ||= @transactions.
        flat_map(&:movements).
        map(&:account).
        select { |account| @account_filter.call(account) }.
        map { |account| @mapper.map(account) }.
        uniq.
        sort
    end

    def months
      @months ||= Range.
        new(*@transactions.map { |t| start_of_month(t.date) }.minmax).
        to_a.
        select { |d| d.day == 1 }
    end

    private
    def start_of_month date
      Date.new date.year, date.month, 1
    end
  end
end
