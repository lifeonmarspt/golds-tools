require 'date'

require_relative 'transaction'
require_relative 'movement'
require_relative 'amount'

module Golds
  module Ledger
    def self.dump transactions
      transactions.map do |transaction|
        Serializer.new(transaction).to_ledger
      end.join("\n\n")
    end

    def self.load source
      source.
        split("\n").
        select { |line| line.match(/\w/) }.
        chunk_while { |before, after| after.match(/^\s/) }.
        map { |lines| Deserializer.new(lines).from_ledger }
    end

    private

    class Serializer < SimpleDelegator
      def to_ledger
        [
          "#{date} #{entity}  ; #{description}",

          *metadata.map do |key, value|
            "  ; #{key}: #{value}"
          end,

          *movements.map do |movement|
            "  #{movement.account} #{"%.2f" % movement.value} #{movement.currency}"
          end
        ].join("\n")
      end
    end

    class Deserializer < SimpleDelegator
      TRANSATION_RE = /(\d{4}-\d{2}-\d{2})\s*(.*)(?:\s\s|\t);\s*(.*)/
      METADATA_RE = /\s+;\s*([^\s]+): (.*)\s*/

      def from_ledger
        header, *lines = self

        date, payee, description = header.match(TRANSATION_RE).captures

        comments, movements = lines.partition { |line| line.match(/^\s+;/) }

        Golds::Transaction.new(
          date: Date.parse(date),
          description: description,
          entity: payee,
          metadata: comments.map do |comment|
            comment.match(METADATA_RE).captures
          end.to_h,
          movements: movements.map do |movement|
            account, amount, unit = movement.strip.split(/\s+/)
            Golds::Movement.new(
              account: account,
              amount: Golds::Amount.new(unit => amount.to_r),
            )
          end,
        )
      end
    end
  end
end
