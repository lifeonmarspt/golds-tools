require 'date'
require 'securerandom'

require_relative 'transaction'
require_relative 'movement'
require_relative 'amount'

module Golds
  module TSV
    def self.dump transactions
      raise
    end

    def self.load source
      source.
        split("\n").
        map(&:rstrip).
        select { |line| line.match(/\w/) }.
        drop_while { |line| line.match(/^\s/) }.
        chunk_while { |before, after| after.match(/^\s/) }.
        map { |lines| Deserializer.new(lines).from_tsv }
    end

    private

    class Deserializer < SimpleDelegator
      def from_tsv
        header, *movements = self
        date, description, payee = header.split("\t")

        description, url = description.split(";", 2)
        id = SecureRandom.uuid

        Golds::Transaction.new(
          date: Date.parse(date),
          description: description,
          entity: payee,
          metadata: [["ID", id], ["URL", url]].select(&:last).to_h,
          movements: movements.map do |movement|
            _, _, account, positive, negative, unit = movement.split("\t")
            Golds::Movement.new(
              account: account,
              amount: Golds::Amount.new(unit => positive.to_r - negative.to_r),
            )
          end,
        )
      end
    end
  end
end
