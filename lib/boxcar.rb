require 'net/http'

class Boxcar
  def self.add_to_boxcar(email)
    Rails.logger.info "Boxcar = #{email}"
    
    uri = URI('http://boxcar.io/devices/providers/i7pThv4s27chmnqFz2FJ/notifications/subscribe')
    res = Net::HTTP.post_form(uri, 'email' => email)
  rescue Errno::ECONNREFUSED => e
    Rails.logger.info "Boxcar Error = #{e.message}"
  end
  
  def self.send_to_boxcar(email,from,msg)
    if Rails.env.development?
      msg = "[test] " + msg
    end

    uri = URI('http://boxcar.io/devices/providers/i7pThv4s27chmnqFz2FJ/notifications/')
    Rails.logger.info "Boxcar = #{email}"

    res = Net::HTTP.post_form(uri, 'email' => email,
            'notification[from_screen_name]' => from,
            'notification[message]' => msg)
  rescue Errno::ECONNREFUSED => e
    Rails.logger.info "Boxcar Error = #{e.message}"
  end

  def self.send_to_boxcar_group(groupname, from, msg)
    Group.users_in_group(groupname).each do |u|
      unless u.boxcar_account.nil?
        unless u.boxcar_account.empty?
          Boxcar.send_to_boxcar(u.boxcar_account, from, msg)
        end
      end
    end
  end

  def self.send_to_boxcar_user(user, from, msg)
    unless user.boxcar_account.nil?
      unless user.boxcar_account.empty?
        Boxcar.send_to_boxcar(user.boxcar_account, from, msg)
      end
    end
  end

end