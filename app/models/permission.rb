class Permission < ActiveRecord::Base
 has_and_belongs_to_many :user

  def self.can_access? (user, controller_name, action_name)
    exception_list = [
        "attachments.picture", "attachments.download",
        "documents.*",
        "hrinfos.index", "hrinfos.show",
        "main.*",
        "users.my", "users.changepw", "users.edit", "users.update",
        "reports.*",
        "expense_reports.*", "cardbills.*", "documents.*"
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
