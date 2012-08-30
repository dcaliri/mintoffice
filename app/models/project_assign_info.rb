class ProjectAssignInfo < ActiveRecord::Base
  belongs_to :project
  belongs_to :participant, polymorphic: true

  has_many :rates, class_name: 'ProjectAssignRate'

  class << self
    def participants_by_project(participant_type, project)
      participant_type = participant_type.to_s.classify

      where(participant_type: participant_type, project_id: project.id)
    end

    def projects_by_participants(participant_type, participant)
      participant_type = participant_type.to_s.classify

      where(participant_type: participant_type, participant_id: participant.id)
    end
  end

  def rate(period)
    100
  end
end