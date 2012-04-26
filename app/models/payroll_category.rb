class PayrollCategory < ActiveRecord::Base
  PAYROLL_TYPE = [
    [:payable, 1],
    [:deductable, 2]
  ]
  
  PAYROLL_CODE = [
    [:etc,    0],
    [:basepay, 1001],
    [:bonus,   1002],
    [:mealsupport, 1003],
    [:carsupport, 1004],
    [:pansion, 2001],
    [:healthcare, 2002],
    [:unemployment, 2003],
    [:healthcare2, 2004],
    [:incometax, 2005],
    [:local_incometax, 2006],
    [:healthcare_adjustment, 2007]
  ]
end