Pushme.setup do |config|
  config.device_types = [ :android ]
  config.table_name = 'shippers'
end

Pushme::Aws.setup do |config|
  config.android_arn = 'arn:aws:sns:us-east-1:128185204017:app/GCM/nilus-shipper-app-dev-android'
end
