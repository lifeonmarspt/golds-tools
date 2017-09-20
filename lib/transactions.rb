class Amount < Struct.new(:data)
  def +(amount)
    Amount.new(data.merge(amount.data) { |k,a,b| a+b })
  end

  def zero?
    data.values.all? { |v| v.zero? }
  end

  def to_s currencies=data.keys
    currencies.
      map { |currency| [currency, data.fetch(currency, 0)] }.
      map { |(currency, amount)| "#{"%.2f" % amount} #{currency}" }.
      join("\t")
  end
end

class Movement < Struct.new(:account, :amount)
  def initialize **kwargs
    super(*members.map { |m| kwargs.fetch(m) })
  end
end

class Transaction < Struct.new(:date, :description, :entity, :movements)
  def initialize **kwargs
    super(*members.map { |m| kwargs.fetch(m) })
  end

  def valid?
    movements.map(&:amount).reduce(&:+).zero?
  end

  def validate!
    throw self unless valid?
  end
end
