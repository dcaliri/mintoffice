# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def tiny_picture_path (attachment)
    url_for :controller => "attachments", :action => 'picture', :id => attachment.id, :w => "100", :h => "80"
  end

  def show_picture_path (attachment)
    url_for(:controller => "attachments", :action => 'picture', :id => attachment.id, :w => "400", :h => "800")
  end

  def forward_params
    params.delete_if{|key, value| key == :controller or key == :action}
  end

  include ExceptColumnView
end
