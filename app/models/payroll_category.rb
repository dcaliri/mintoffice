class PayrollCategoryUniqueness < ActiveModel::Validator
  def validate(record)
    if record.code != Hash[PayrollCategory::PAYROLL_CODE][:etc]
      if record.prtype == Hash[PayrollCategory::PAYROLL_TYPE][:payable] && ( record.code < 1000 || record.code > 2000 )
        record.errors[:base] << I18n.t("payroll_categories.validate.payable_code_not_match")
      elsif record.prtype == Hash[PayrollCategory::PAYROLL_TYPE][:deductable] && ( record.code < 2000 || record.code > 3000 )
        record.errors[:base] << I18n.t("payroll_categories.validate.deductable_code_not_match")
      elsif PayrollCategory.where(:code => record.code).count() > 0
        record.errors[:base] << I18n.t("payroll_categories.validate.already_exists")
      end
    end
  end
end

class PayrollCategory < ActiveRecord::Base
  
  has_many :payroll_items
  validates_with PayrollCategoryUniqueness
  
  PAYROLL_TYPE = [
    [:payable, 1],
    [:deductable, 2]
  ]
  
  PAYROLL_CODE = [
    [:etc,    1],
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

  class << self
    def payable
      where(prtype: 1)
    end

    def deductable
      where(prtype: 2)
    end
  end
  
end

