class Transaction
  def to_ledger
    indent = [48, *movements.map(&:account).map(&:length)].max + 8

    (
      ["#{date} #{entity}  ; #{description}"] +
      movements.map do |movement|
        "  %-#{indent}s %12s %s" % [
          movement.account,
          "%.2f" % movement.amount.data.values[0],
          movement.amount.data.keys[0],
        ]
      end
    ).join("\n")
  end
end
