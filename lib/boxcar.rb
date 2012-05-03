require 'net/http'

class Boxcar
  def self.send_to_boxcar(email,from,msg)
    uri = URI('http://boxcar.io/devices/providers/Cng5l1heQIUb67QvOpsY/notifications/')
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
end