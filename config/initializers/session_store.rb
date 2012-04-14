Mintoffice::Application.config.session_store :cookie_store, key: '_mintoffice_session'

# # Be sure to restart your server when you modify this file.
# 
# # Your secret key for verifying cookie session data integrity.
# # If you change this key, all old sessions will become invalid!
# # Make sure the secret is at least 30 characters and all random, 
# # no regular words or you'll be exposed to dictionary attacks.
# ActionController::Base.session = {
#   :key         => '_mintoffice_session',
#   :secret      => '52ccb366e04c6b25573fa187834fec23e4451bd081a5a96ba9ef8d4cf3f3015158a3613129dc1aee9c3f0a7adc4a904e42fd50e3a2a4fc2b0f58aebbb176fccc'
# }
# 
# # Use the database for sessions instead of the cookie-based default,
# # which shouldn't be used to store highly confidential information
# # (create the session table with "rake db:sessions:create")
# # ActionController::Base.session_store = :active_record_store
