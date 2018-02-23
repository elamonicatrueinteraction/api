Shippify::Api.setup do |config|
  config.key = SHIPPIFY_API['key']
  config.secret = SHIPPIFY_API['secret']
end

Shippify::Dash.setup do |config|
  if SHIPPIFY_DASH['access_token']
    config.access_token = SHIPPIFY_DASH['access_token']
  else
    config.user_email = SHIPPIFY_DASH['email']
    config.user_password = SHIPPIFY_DASH['password']
  end

  config.company_id = SHIPPIFY_DASH['company_id']
end
