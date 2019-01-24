Aws.config.update({
  region: Rails.application.secrets.aws_region,
  credentials: Aws::Credentials.new(
    Rails.application.secrets.aws_credentials_access_key,
    Rails.application.secrets.aws_credentials_secret_key
  )
})
