Aws.config.update({
  region: AWS_REGION,
  credentials: Aws::Credentials.new(AWS_CREDENTIALS['access_key'], AWS_CREDENTIALS['secret_key'])
})
