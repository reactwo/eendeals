SimpleTokenAuthentication.configure do |config|
  config.header_names = { user: { authentication_token: 'X-User-Token', mobile: 'X-User-Mobile' } }

  config.identifiers = { user: 'mobile' }
end