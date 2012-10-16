class Permission < ActiveRecord::Base
  has_and_belongs_to_many :groups
  has_and_belongs_to_many :people

  validates :name, presence: true, uniqueness: true

  def self.can_access? (person, controller_name, action_name)
    exception_list = [
        "attachments.picture", "attachments.download", "attachments.delete",
        "documents.*",
        "employees.index", "employees.show", "employees.new_employment_proof", "employees.employment_proof",
        "main.*",
        "accounts.my", "accounts.changepw", "accounts.changepw_form", "accounts.edit", "accounts.update", "accounts.google_apps",
        "reports.*",
        "expense_reports.*", "cardbills.*", "documents.*",
        "except_columns.*",
        "projects.*",
        "accessors.*",
        "contacts.*"
      ]

    perm_action = controller_name + "."+ action_name
    perm_all = controller_name + ".*"

    if exception_list.index(perm_action) || exception_list.index(perm_all)
      return true
    end

    return false unless person and person.employee
    return true if person and person.admin?

    if person.permission?(controller_name)
      return true
    else
      return false
    end
  end

  def self.permission?(name)
    exists?(name: name.to_s)
  end

  def to_param
    name
  end
end
