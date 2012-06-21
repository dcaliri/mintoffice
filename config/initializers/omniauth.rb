Rails.application.config.middleware.use OmniAuth::Builder do
  require 'openid/store/filesystem'

  config = OpenStruct.new(YAML.load_file('config/oauth_key.yml'))

  provider :openid, :store => OpenID::Store::Filesystem.new('/tmp'), :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
  provider :daum, config.daum['consumer_key'], config.daum['consumer_secret']
  provider :nate, config.nate['consumer_key'], config.nate['consumer_secret'],
        :encryption => {
          :key => config.nate['encryption_key'], # Required.
          :iv  => 0.chr * 8,                    # Optional. Default: 0.chr * 8
          :algorithm => 'des-ede3-cbc'          # Optional. Default: des-ede3-cbc
        }

end