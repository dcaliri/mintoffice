# encoding: UTF-8

class AccessPerson < ActiveRecord::Base
  belongs_to :owner, polymorphic: true
  belongs_to :access_target, polymorphic: true

  class << self
    def no_permission
      group(:access_target_id).having('count(access_people.access_target_id) = 0')
    end

    def access_list(owner)
      if owner.admin?
        where("1")
      elsif owner.nil?
        where("0")
      else
        arel = self.arel_table
        query = arel[:owner_type].eq("Person").and(arel[:owner_id].eq(owner.id))
        unless owner.groups.empty?
          group_ids = owner.group_list.map(&:id)
          query = query.or(arel[:owner_type].eq("Group").and(arel[:owner_id].in(group_ids)))
        end
        where(query)
      end
    end

    def access?(owner, access_type)
      return true if owner.admin?
      access_query = access_type == :write ? {access_type: :write} : {}

      collection = where(access_query)
      exist_person = collection.where(owner_type: "Person").exists?(owner_id: owner.id)
      exist_group = collection.where(owner_type: "Group").exists?(owner_id: owner.group_list.map(&:id))

      exist_person or exist_group
    end

    def readers
      where(access_type: [:read, :write])
    end

    def writers
      where(access_type: :write)
    end

    def permission(owner, access_type)
      collection = where(owner_type: owner.class.to_s, owner_id: owner.id)
      unless collection.empty?
        accessor = collection.first
        accessor.access_type = access_type
        accessor.save!
      else
        create!(owner_type: owner.class.to_s, owner_id: owner.id, access_type: access_type)
      end
    end
  end

  def fullname
    if self.owner_type == "Person"
      "[개인] " + owner.account.fullname rescue ""
    elsif owner.class == Group
      "[그룹] " + owner.name
    end
  end

  def read?
    [:read, :write].include? access_type.to_sym
  end

  def write?
    access_type.to_sym == :write
  end
end