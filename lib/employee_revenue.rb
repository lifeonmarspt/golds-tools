class EmployeeRevenue < Struct.new(:hourly_rate, :billable_time)
  def hours_per_day
    6
  end

  def days_per_month
    21
  end

  def yearly
    (hourly_rate * hours_per_day * days_per_month * 11) * billable_time
  end
end
