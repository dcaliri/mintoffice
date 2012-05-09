module Attachmentable
  def save_attachment_id(resource)
    session[:attachments] = [] if session[:attachments].nil?
    resource.attachments.each { |at| session[:attachments] << at.id }
  end
end