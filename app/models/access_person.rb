class AccessPerson < ActiveRecord::Base
  belongs_to :user
  belongs_to :access_target, polymorphic: true

  class << self
    def no_permission
      group(:access_target_id).having('count(access_people.access_target_id) = 0')
    end

    def access_list(user)
      if user.admin?
        where("1")
      elsif user.nil?
        where("0")
      else
        where(user_id: user.id)
      end
    end

    def access?(user, access_type)
      return true if user.admin?
      access_query = access_type == :write ? {access_type: :write} : {}
      where(access_query).exists?(user_id: user.id)
    end

    def readers
      where(access_type: [:read, :write])
    end

    def writers
      where(access_type: :write)
    end

    def permission(user, access_type)
      collection = where(user_id: user.id)
      unless collection.empty?
        accessor = collection.first
        accessor.access_type = access_type
        accessor.save!
      else
        create!(user_id: user.id, access_type: access_type)
      end
    end
  end

  def fullname
    user.name
  end
end