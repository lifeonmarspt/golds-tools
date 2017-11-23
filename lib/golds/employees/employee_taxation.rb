module Golds
  module Employees
    class EmployeeTaxation < Struct.new(:salary, :dependents)
      def withholding_data
        DATA.split("\n").map {|line| line.split.map(&:to_r) }
      end

      def yearly_social_security
        salary.yearly * Rational(11, 100)
      end

      def withholding_income_tax_rate
        Rational(1, 100) * withholding_data.find { |r| r[0] > salary.monthly }[1+[5,dependents].min]
      end

      def yearly_withheld_income_tax
        salary.yearly * withholding_income_tax_rate
      end

      def yearly_total
        yearly_social_security + yearly_withheld_income_tax
      end

      DATA = <<DATA
  615.00  0.0  0.0  0.0  0.0  0.0  0.0
  623.00  1.8  0.0  0.0  0.0  0.0  0.0
  645.00  5.0  0.0  0.0  0.0  0.0  0.0
  683.00  6.0  1.4  0.0  0.0  0.0  0.0
  736.00  7.5  2.9  0.3  0.0  0.0  0.0
  811.00  8.5  4.9  1.3  0.0  0.0  0.0
  919.00 11.0  7.4  3.8  0.2  0.0  0.0
 1001.00 12.5  8.9  6.3  1.7  0.0  0.0
 1061.00 13.5  9.9  7.3  3.7  0.1  0.0
 1139.00 14.5 11.9  9.3  5.7  3.1  0.5
 1221.00 15.5 13.0 10.3  6.7  4.1  1.5
 1317.00 16.5 14.0 11.4  7.7  5.1  2.5
 1419.00 17.5 15.0 12.4  8.8  7.1  4.5
 1557.00 18.5 16.0 13.4 10.8  8.2  5.5
 1705.00 20.0 17.5 15.9 12.3  9.7  7.1
 1864.00 21.5 19.6 18.6 15.6 13.6 12.6
 1971.00 22.5 20.8 19.6 16.6 15.6 13.6
 2083.00 23.5 21.8 20.8 17.6 16.6 14.6
 2211.00 24.5 22.8 21.8 18.8 17.6 15.6
 2359.00 25.5 23.8 22.8 19.8 18.8 16.6
 2527.00 26.5 25.8 23.8 21.8 19.8 18.8
 2758.00 27.5 26.8 24.8 22.8 20.8 19.8
 3094.00 28.5 27.8 25.8 23.8 21.8 20.8
 3523.00 29.5 29.2 27.6 26.0 25.4 23.8
 4105.00 30.7 30.5 28.6 27.0 26.4 25.8
 4636.00 32.5 32.0 30.4 28.5 27.9 27.3
 5178.00 33.5 33.0 32.4 29.8 28.9 28.3
 5862.00 34.5 34.0 33.4 30.8 30.2 29.3
 6706.00 36.5 36.1 35.3 33.4 33.0 32.6
 7915.00 37.5 37.1 36.7 35.4 34.0 33.6
 9531.00 39.5 39.1 38.7 37.4 37.0 35.6
11248.00 40.5 40.1 39.7 38.8 38.0 36.6
18797.00 41.5 41.1 40.7 39.8 39.4 37.6
20160.00 42.5 42.1 41.7 40.8 40.4 38.6
22680.00 43.3 43.1 42.7 41.8 41.4 39.8
25200.00 44.3 44.1 43.7 42.8 42.4 41.0
99999.99 45.3 45.1 44.7 43.8 43.4 42.0
DATA
    end
  end
end