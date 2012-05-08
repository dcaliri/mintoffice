# module NewHistoriable
#   extend ActiveSupport::Concern
#
#   def history_parent
#     self
#   end
#   def history_info
#     {}
#   end
#
#   def history_except
#     []
#   end
#
#   def make_histories
#     changes.each do |k,v|
#       next if v[0].to_s == v[1].to_s
#       next if history_except.include?(k.to_sym)
#       info = history_info[k.to_sym]
#
#       history_parent.change_histories.create(
#         :fieldname => k,{}
#         :before_value => info ? info.call(self, v[0]) : v[0].to_s,
#         :after_value => info ? info.call(self, v[1]) : v[1].to_s,
#         :user => User.current_user
#       )
#     end unless history_parent.new_record?
#   end
#
#   included do
#     has_many(:change_histories, :as => :changable)
#     before_save :make_histories
#   end
# end

class ActiveRecord::Base
  def self.historiable
    @history_opts = {
      :parent => self,
      :except => [],
      :description => {}
    }
    yield @history_opts
  end
end

class ContactEmail < ActiveRecord::Base
  belongs_to :contact
  has_and_belongs_to_many :tags, :class_name => 'ContactEmailTag'

  include Historiable
  def history_parent
    contact
  end
  def history_except
    [:target, :contact_id]
  end
  def history_info
    {
      :email => proc { |email, v| "[#{email.target}]#{v}" }
    }
  end

  def self.search(query)
    where("email like ?", query)
  end
end