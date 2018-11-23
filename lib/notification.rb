# Notification.push('arn:aws:sns:us-east-1:128185204017:app/GCM/nilus-shipper-app-dev-android', 'default', 'HOLA!', {}, true)

# TO-DO: We should move all this to the Pushme Gem
class Notification
  class Error < ::StandardError; end

  def self.push(token, text, push_content = {}, stub_responses = false)
    sns = Aws::SNS::Client.new(stub_responses: stub_responses)

    # Determine device -> message recipient
    endpoint_arn = sns.create_platform_endpoint(
      platform_application_arn: SNS_SETUP['arn']['android'],
      token: token
    ).endpoint_arn

    payload = {
      data: {
        message: text
      }.merge(push_content)
    }

    message = {
      default: payload.to_json,
      GCM: payload.to_json
    }.to_json

    # Pushing message to device through endpoint_arn
    Rails.logger.info "ARN: #{endpoint_arn}"
    Rails.logger.info "message: #{message}"
    sns.publish(
      target_arn: endpoint_arn,
      message: message,
      message_structure: "json",
    )

  # Some error handling need to be made
  rescue Aws::SNS::Errors::ServiceError => e
    Rails.logger.info endpoint_arn
    Rails.logger.info e.inspect
    raise Notification::Error.new(e)
  end

end
