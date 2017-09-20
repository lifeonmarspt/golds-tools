#!/usr/bin/env ruby

class EmployeeIncomeTax < Struct.new(:total_income, :ss_withheld)

end

class TaxRate
  def data
    [
      [  7091, 14.50,    0.00],
      [ 20261, 28.50,  992.74],
      [ 40522, 37.00, 2714.93],
      [ 80640, 45.00, 5956.69],
      [999999, 48.00, 8375.89],
    ]
  end

  def tax income
    ranking = data.find { |r| r[0] > income }

    ranking[1] * income - ranking[2]
  end
end

class IRSRates
  def initialize(table)
    self.table = table
    make_parcel_table
  end

  def ranking(collectable)
    sorted([x for x in table.keys() if x >= collectable])[0]
  end

  def tax(collectable)
    table[ranking(collectable)]
  end

  def parcel(collectable)
    parcel_for(ranking(collectable))
  end

  def make_parcel_table()
    items = sorted(self.table.keys())

    self.parcels = {}

    p = 0
    s = 0
    for k in items
      s += (self.table[k] - self.table[p]) * p
      self.parcels[k] = s
      p = k
    end
  end

  def parcel_for(ranking):
    parcels[ranking]
  end
end
