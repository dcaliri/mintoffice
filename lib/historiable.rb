module Historiable
  extend ActiveSupport::Concern

  def make_histories
    changes.each do |k,v|
      change_histories.build(
        :fieldname => k,
        :before_value => v[0].to_s,
        :after_value => v[1].to_s,
        :user => User.current_user
      )
    end
  end

  included do
    has_many(:change_histories, :as => :changable)
    before_save :make_histories
  end
end