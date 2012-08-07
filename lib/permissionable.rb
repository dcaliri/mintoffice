module Permissionable
  extend ActiveSupport::Concern

  module ClassMethod
    def no_permission
      includes(:accessors).merge(AccessPerson.no_permission)
    end

    def access_list(person)
      joins(:accessors).merge(AccessPerson.access_list(person))
    end
  end

  def access?(person, permission_type = :read)
    unless accessors.empty?
      accessors.access?(person, permission_type)
    else
      person.admin?.tap do |admin|
        accessors.permission(person, :write) if admin
      end
    end
  end

  def permission(person, access_type)
    accessors.permission(person, access_type)
  end

  included do
    has_many :accessors, class_name: 'AccessPerson', as: 'access_target'
    extend ClassMethod
  end
end