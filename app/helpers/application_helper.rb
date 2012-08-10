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
  
  def ns str
    return '&nbsp;' if str.instance_of? NilClass
    if str.instance_of? String
      str.strip.empty? ? '&nbsp;' : str
    elsif str.instance_of? Date or str.instance_of? ActiveSupport::TimeWithZone
      l str
    elsif str.instance_of? BigDecimal
      number_to_currency str
    else
      str
    end
  end
  
  def dtdd obj, p_str
#    content_tag :dl do
      html = content_tag :dt, obj.class.human_attribute_name(p_str)
      html += content_tag :dd, ns(obj.send(p_str.to_sym)), nil, false
      html
#    end
  end

  include ExceptColumnView
end
