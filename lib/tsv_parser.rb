require 'date'

require_relative './transactions.rb'

def parse_tsv file
  file.
    readlines.
    map(&:rstrip).
    select { |line| line.match(/\w/) }.
    drop_while { |line| line.match(/^\s/) }.
    chunk_while { |before, after| after.match(/^\s/) }.
    map do |(header, *movements)|
      date, description, entity = header.split("\t")

      Transaction.new(
        date: Date.parse(date),
        description: description,
        entity: entity,
        movements: movements.map do |movement|
          _, _, account, positive, negative, unit = movement.split("\t")
          Movement.new(
            account: account,
            amount: Amount.new(unit => positive.to_r - negative.to_r),
          )
        end,
      )
    end.
    each(&:validate!).
    itself
end
