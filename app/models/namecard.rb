class Namecard < ActiveRecord::Base
  include Attachmentable

  def self.search(query)
    query = "%#{query}%"
    where('name like ? OR jobtitle like ? OR department like ? OR company like ? OR phone like ? OR email like ? OR homepage like ?', query, query, query, query, query, query, query)
  end
end
