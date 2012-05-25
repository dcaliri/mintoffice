module Permissionable
  extend ActiveSupport::Concern

  module ClassMethod
    def access_list(user)
      joins(:accessors).merge(AccessPerson.access_list(user))
    end
  end

  def access?(user, permission_type = :read)
    accessors.access?(user, permission_type)
  end

  def permission(user, access_type)
    accessors.permission(user, access_type)
  end

  included do
    has_many :accessors, class_name: 'AccessPerson', as: 'access_target'
    extend ClassMethod
  end
end