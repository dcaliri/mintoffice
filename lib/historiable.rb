module Historiable
  extend ActiveSupport::Concern

  def parent
    self
  end

  def make_histories
    changes.each do |k,v|
      parent.change_histories.create(
        :fieldname => k,
        :before_value => v[0].to_s,
        :after_value => v[1].to_s,
        :user => User.current_user
      )
    end unless parent.new_record?
  end

  included do
    has_many(:change_histories, :as => :changable)
    before_save :make_histories
  end
end