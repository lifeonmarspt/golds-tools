require 'date'

require_relative './transactions.rb'
require_relative './ledger_generator.rb'

def parse_ledger file
  file.
    readlines.
    select { |line| line.match(/\w/) }.
    chunk_while { |before, after| after.match(/^\s/) }.
    map do |(header, *movements)|
      matches =  header.match(/(\d{4}-\d{2}-\d{2})\s*(.*)(?:(?:\s\s|\t);\s*(.*))/)
      date = matches[1]
      payee = matches[2]
      description = matches[3]

      Transaction.new(
        date: Date.parse(date),
        description: description,
        entity: payee,
        movements: movements.map do |movement|
          account, amount, unit = movement.strip.split(/\s+/)
          Movement.new(
            account: account,
            amount: Amount.new(unit => amount.to_r),
          )
        end,
      )
    end.
    each(&:validate!).
    itself
end
