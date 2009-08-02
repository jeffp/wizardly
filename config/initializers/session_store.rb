# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_wizard_session',
  :secret      => 'bbd1b39720a747639fea9e3b40b5db4d67cabdedab097746587fdd9d390c1ce2108d812fd23054eb9ac0c6d4bbb07357a532cd8cf0e847cac5cc319ab1364175'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
