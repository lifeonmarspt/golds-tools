#!/usr/bin/env ruby

class CompanyCost < Struct.new(:gross_salary)
  def yearly_salary
    gross_salary.yearly
  end

  def yearly_social_security
    gross_salary.yearly * 0.2375
  end

  def yearly_food_allowance
    4.52 * 21 * 11
  end

  def yearly_health_insurance
    gross_salary.yearly * 0.01
  end

  def yearly_total
    (
      yearly_salary +
      yearly_social_security +
      yearly_food_allowance +
      yearly_health_insurance
    )
  end
end
