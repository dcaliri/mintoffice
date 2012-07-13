class Permission < ActiveRecord::Base
  has_and_belongs_to_many :user

  validates :name, presence: true, uniqueness: true

  def self.can_access? (user, controller_name, action_name)
    exception_list = [
        "attachments.picture", "attachments.download",
        "documents.*",
        "hrinfos.index", "hrinfos.show", "hrinfos.new_employment_proof", "hrinfos.employment_proof",
        "main.*",
        "users.my", "users.changepw", "users.edit", "users.update", "users.google_apps",
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

    if user.permission.any? { |perm| perm.name == controller_name }
      return true
    else
      return false
    end
  end
end
