module Golds
  module Employees
    class GrossSalary < Struct.new(:monthly)
      def yearly
        monthly * 14
      end
    end
  end
end
