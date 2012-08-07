class AccessPerson < ActiveRecord::Base
  belongs_to :person
  belongs_to :access_target, polymorphic: true

  class << self
    def no_permission
      group(:access_target_id).having('count(access_people.access_target_id) = 0')
    end

    def access_list(person)
      if person.admin?
        where("1")
      elsif person.nil?
        where("0")
      else
        if person.class == Account
          where(person_id: person.person.id)
        else
          where(person_id: person.id)
        end
      end
    end

    def access?(person, access_type)
      return true if person.admin?
      access_query = access_type == :write ? {access_type: :write} : {}
      if person.class == Account
        where(access_query).exists?(person_id: person.person.id)
      else
        where(access_query).exists?(person_id: person.id)
      end
    end

    def readers
      where(access_type: [:read, :write])
    end

    def writers
      where(access_type: :write)
    end

    def permission(person, access_type)
      if person.class == Account
        collection = where(person_id: person.person.id)
      else
        collection = where(person_id: person.person.id)
      end
      unless collection.empty?
        accessor = collection.first
        accessor.access_type = access_type
        accessor.save!
      else
        if person.class == Account
          create!(person_id: person.person.id, access_type: access_type)
        else
          create!(person_id: person.id, access_type: access_type)
        end
      end
    end
  end

  def fullname
    person.account.fullname rescue ""
  end

  def read?
    [:read, :write].include? access_type.to_sym
  end

  def write?
    access_type.to_sym == :write
  end
end