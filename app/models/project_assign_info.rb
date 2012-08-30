class ProjectAssignInfo < ActiveRecord::Base
  belongs_to :project
  belongs_to :participant, polymorphic: true

  has_many :rates, class_name: 'ProjectAssignRate'

  class << self
    def participants_by_project(participant_types, ids)
      participant_type = revise_types(participant_types)
      where(participant_type: participant_type, project_id: ids)
    end

    def projects_by_participant(participant_types, ids)
      participant_types = revise_types(participant_types)
      where(participant_type: participant_types, participant_id: ids)
    end

    def revise_types(types)
      unless types.class == Array
        types = [types]
      end
      types.map{|type| type.to_s.classify}
    end
  end

  def rate(period)
    100
  end
end