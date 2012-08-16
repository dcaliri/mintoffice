module Historiable
  extend ActiveSupport::Concern

  def history_parent
    self
  end
  def history_info
    {}
  end

  def history_except
    []
  end

  def make_histories
    changes.each do |k,v|
      next if v[0].to_s == v[1].to_s
      next if history_except.include?(k.to_sym)
      info = history_info[k.to_sym]

      history_parent.change_histories.create(
        :target => self.class.to_s,
        :fieldname => k,
        :before_value => info ? info.call(self, v[0]) : v[0].to_s,
        :after_value => info ? info.call(self, v[1]) : v[1].to_s,
        :employee => Person.current_person ? Person.current_person.employee : nil
      )
    end if history_parent.present? and not history_parent.new_record?
  end

  included do
    has_many(:change_histories, :as => :changable)
    before_save :make_histories
  end
end