#!/usr/bin/env ruby

class GrossSalary < Struct.new(:monthly)
  def yearly
    monthly * 14
  end
end
