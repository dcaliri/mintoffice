module ActionController
  module Extensions
    module Attachment
      extend ActiveSupport::Concern

      def save_attachment_id(resource)
        @attachment_ids ||= []
        resource.attachments.each { |at| @attachment_ids << at.id }
        session[:attachments] = @attachment_ids
      end
    end
  end
end