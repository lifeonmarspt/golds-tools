require 'date'
require 'json'

module Golds
  module JSON
    def self.dump transactions
      ::JSON.dump(
        transactions.map do |transaction|
          Serializer.new(transaction).to_json
        end
      )
    end

    def self.load source
      ::JSON.
        parse(source).
        map { |transaction| Deserializer.new(transaction).from_json }
    end

    private
    class Serializer < SimpleDelegator
      def to_json
        {
          "date" => date.to_s,
          "description" => description,
          "payee" => entity,
          "metadata" => metadata,
          "movements" => movements.map do |movement|
            {
              "account" => movement.account,
              "currency" => movement.currency,
              "amount" => (movement.value * 100).to_i,
            }
          end,
        }
      end
    end

    class Deserializer < SimpleDelegator
      def from_json
        Golds::Transaction.new(
          date: Date.parse(fetch("date")),
          description: fetch("description"),
          entity: fetch("payee"),
          metadata: fetch("metadata"),
          movements: fetch("movements").map do |movement|
            Golds::Movement.new(
              account: movement.fetch("account"),
              amount: Golds::Amount.new(
                movement.fetch("currency") => movement.fetch("amount").to_r / 100
              )
            )
          end,
        )
      end
    end
  end
end
