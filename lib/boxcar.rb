require 'net/http'

class Boxcar
  def self.send_to_boxcar(email,from,msg)
    if Rails.env.development?
      msg = "[test] " + msg
    end
    uri = URI('http://boxcar.io/devices/providers/i7pThv4s27chmnqFz2FJ/notifications/')
		res = Net::HTTP.post_form(uri, 'email' => email,
						'notification[from_screen_name]' => from,
						'notification[message]' => msg);		
  end
  
  def self.send_to_boxcar_group(groupname, from, msg)
    Group.users_in_group(groupname).each do |u|
      if ! u.boxcar_account.empty?
        Boxcar.send_to_boxcar(u.boxcar_account, from, msg)
      end
    end
  end
  
  def self.send_to_boxcar_user(user, from, msg)
    unless user.boxcar_account.empty?
      Boxcar.send_to_boxcar(user.boxcar_account, from, msg)
    end
  end
  
end