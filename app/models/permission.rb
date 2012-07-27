class Permission < ActiveRecord::Base
  # has_and_belongs_to_many :account
  # has_and_belongs_to_many :employees
  has_and_belongs_to_many :people

  ### deprecated methods
  # def employee
  #   add_to_fix_me_log('employee')
  #   employees
  # end
  ### deprecated methods



  validates :name, presence: true, uniqueness: true

  def self.can_access? (account, controller_name, action_name)
    exception_list = [
        "attachments.picture", "attachments.download",
        "documents.*",
        "employees.index", "employees.show", "employees.new_employment_proof", "employees.employment_proof",
        "main.*",
        "accounts.my", "accounts.changepw", "accounts.edit", "accounts.update", "accounts.google_apps",
        "reports.*",
        "expense_reports.*", "cardbills.*", "documents.*",
        "accessors.*",
        "contacts.*"
      ]

    perm_action = controller_name + "."+ action_name
    perm_all = controller_name + ".*"

    if exception_list.index(perm_action) || exception_list.index(perm_all)
      return true
    end

    return false unless account and account.employee
    return true if account and account.admin?
    
    if account.person.permissions.any? { |perm| perm.name == controller_name }
      return true
    else
      return false
    end
  end
end
