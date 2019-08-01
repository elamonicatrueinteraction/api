meli_tokens = Tenant::TenantMeliTokens.new
missing_meli_credentials = meli_tokens.lacks_tokens_of

if missing_meli_credentials.any?
  puts "[Credentials] - Missing meli credentials: #{missing_meli_credentials.inspect}"
end

meli_emails = Tenant::TenantEmail.new
missing_meli_emails = meli_emails.lack_emails_of

if missing_meli_emails.any?
  puts "[Credentials] - Missing meli emails: #{missing_meli_emails}"
end