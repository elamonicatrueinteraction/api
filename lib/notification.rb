# Notification.push('arn:aws:sns:us-east-1:128185204017:app/GCM/nilus-shipper-app-dev-android', 'default', 'HOLA!', {}, true)
class Notification

  def self.push(platform_application_arn, token, text, push_content, stub_responses = false)
    sns = Aws::SNS::Client.new(stub_responses: stub_responses)

    # Determine device -> message recipient
    endpoint = sns.create_platform_endpoint(
      platform_application_arn: platform_application_arn,
      token: token
    ).endpoint_arn

    # Define a push notification message with metadata
    payload = {
      notification_id: "15",
      aps: {
        alert: text,
        badge: 1,
        sound: "default"
      },

      push_content: push_content
    }

    # The same message will be sent to production and sandbox
    message = {
      APNS: payload.to_json,
      APNS_SANDBOX: payload.to_json
    }.to_json

    # Pushing message to device through endpoint
    resp = sns.publish(
      target_arn: endpoint,
      message: message,
      message_structure: "json",
    )

  # Some error handling need to be made
  rescue Aws::SNS::Errors::ServiceError => e
    binding.pry
    false
  end
end
