# encoding: UTF-8

module EmployeesHelper
  def options_for_employees_select(employee)
    id = employee.id rescue nil
    collection = Employee.not_retired
    collection.map!{|employee| [employee.fullname, employee.id]}
    collection.unshift(["없음", nil])

    options_for_select(collection, id)
  end
end
