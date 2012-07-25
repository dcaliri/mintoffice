module Permissionable
  extend ActiveSupport::Concern

  module ClassMethod
    def no_permission
      includes(:accessors).merge(AccessPerson.no_permission)
    end

    def access_list(account)
      joins(:accessors).merge(AccessPerson.access_list(account))
    end
  end

  def access?(account, permission_type = :read)
    unless accessors.empty?
      accessors.access?(account, permission_type)
    else
      account.ingroup?(:admin).tap do |admin|
        accessors.permission(account, :write) if admin
      end
    end
  end

  def permission(account, access_type)
    accessors.permission(account, access_type)
  end

  included do
    has_many :accessors, class_name: 'AccessPerson', as: 'access_target'
    extend ClassMethod
  end
end