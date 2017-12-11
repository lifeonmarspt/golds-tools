require_relative 'ledger'
require_relative 'config'
require_relative 'account_mapper'
require_relative 'monthly_report'

module Golds
  class Commands
    attr_reader :config

    def initialize options
      @config = Config.new(options)
    end

    CASH_ACCOUNT = /^Assets:Cash(:|$)/
    PNL_ACCOUNT = /^(Revenues|Expenses|Exchanges|Assets:Equipment)(:|$)/
    CURRENCIES = ["EUR", "USD", "GBP"]

    def amount_to_s value
      if value != 0
        "%.2f" % value
      else
        ""
      end
    end

    def cashflow
      mapper = Golds::AccountMapper.new(config.cashflow_mapping)

      cash_transactions = Golds::Ledger.
        load(File.read(config.file)).
        select { |transaction| transaction.accounts.grep(CASH_ACCOUNT).any? }

      report = Golds::MonthlyReport.new(
        cash_transactions,
        mapper,
        ->(account) { !account.match(CASH_ACCOUNT) },
      )

      print_monthly_report report
    end

    def profit_and_loss
      mapper = Golds::AccountMapper.new(config.pnl_mapping)

      transactions = Golds::Ledger.load(File.read(config.file)).
        select { |transaction| transaction.accounts.grep(PNL_ACCOUNT).any? }

      report = Golds::MonthlyReport.new(
        transactions,
        mapper,
        ->(account) { account.match(PNL_ACCOUNT) },
      )

      print_monthly_report report
    end

    private
    def print_monthly_report report
      report.accounts.
        map do |account|
          [
            account,
            *report.months.product(CURRENCIES).map do |month, currency|
              amount_to_s(-report.amount(month, account).value(currency))
            end
          ]
        end.
        map { |rows| rows.join(",") }.
        join("\n").
        tap { |report| puts report }
    end
  end
end
