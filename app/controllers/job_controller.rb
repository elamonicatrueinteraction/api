class JobController < ApplicationController

  before_action :authorize
  skip_before_action :authorize_request
  skip_before_action :set_current_network

  def sync_coupons
    Rails.logger.info '[PaymentSync] - Starting Sync'
    begin
      payment_sync = Gateway::PaymentSync.new
      debt_update = Payments::UpdateInstitutionDebt.new
      payment_sync.sync_payments
      Rails.logger.info '[PaymentSync] - Sync ended succesfully!'
      Rails.logger.info '[PaymentSync] - Updating institution debt...'
      debt_update.update_all
      Rails.logger.info '[PaymentSync] - Finished updating institution debt...'
      return render plain: "OK", status: :ok
    rescue StandardError => e
      Rails.logger.info "[PaymentSync] - ERROR in payment sync. Message: #{e}"
      return render plain: "ERROR #{e.message}", status: :internal_server_error
    end
  end

  def sync_missing_coupons
    Rails.logger.info '[MissingPaymentSync] - Starting Sync'
    begin
      payment_sync = Gateway::RemoteNotFoundPaymentSync.new
      debt_update = Payments::UpdateInstitutionDebt.new
      payment_sync.sync_payments
      Rails.logger.info '[MissingPaymentSync] - Sync ended succesfully!'
      Rails.logger.info '[MissingPaymentSync] - Updating institution debt...'
      debt_update.update_all
      Rails.logger.info '[MissingPaymentSync] - Finished updating institution debt...'
      return render plain: "OK", status: :ok
    rescue StandardError => e
      Rails.logger.info "[MissingPaymentSync] - ERROR in payment sync. Message: #{e}"
      return render plain: "ERROR #{e.message}", status: :internal_server_error
    end
  end

  def cancel_remote_payment
    payment_id = cancel_payment_params[:payment_id]
    payment = Payment.find_by(id: payment_id)
    if payment.nil?
      message = "El pago con id #{payment_id} no fue encontrado"
      result = JobResult.new(name: "CancelRemotePaymentJob", result: JobResult::Types::FAILED,
                             message: message, extra_info: {})
      result.save!
      return render plain: "Cancellation was unsuccesfull", status: :ok
    end
    unless payment.has_remote?
      message = "El pago con id #{payment_id} no fue encontrado"
      result = JobResult.new(name: "CancelRemotePaymentJob", result: JobResult::Types::FAILED,
                             message: message, extra_info: {})
      result.save!
      return render plain: "Cancellation was unsuccesfull", status: :ok
    end
    payment_canceler = Gateway::Mercadopago::CancelRemotePayment.new
    data = payment_canceler.cancel_payment(payment)
    if data.raw_data['status'].to_i == 200
      message = "La cancelación del cupón remoto del pago #{payment_id} fue exitosa"
      result = JobResult.new(name: "CancelRemotePaymentJob", result: JobResult::Types::SUCCESSFUL,
                             message: message, extra_info: data.raw_data)
      result.save!
      render plain: "OK", status: :ok
    else
      message = "Couldn't cancel remote payment of #{payment_id}. Request went with status code #{data.raw_data['status'].to_i}"
      result = JobResult.new(name: "CancelRemotePaymentJob", result: JobResult::Types::FAILED,
                             message: message, extra_info: data.raw_data)
      result.save!
      render plain: "Cancellation was unsuccesfull", status: :ok
    end
  end

  def backup
    # pg_dump --host="127.0.0.1" --port="5432" --username="sa" --no-password --verbose -F c axum_censos_cmq_dev > cmq-live-20180917.sql
    conn = ActiveRecord::Base.connection_config
    host = conn[:host]
    port = conn[:port]
    user = conn[:username]
    db = conn[:database]
    password = conn[:password]
    outputFile = "#{Time.now.getutc.strftime("%Y%m%d%H%M")}-logistic.backup"
    command = "pg_dump --host=\"#{host}\" --port=\"#{port}\" --username=\"#{user}\" "\
              "--no-password --verbose -F c -f #{outputFile} #{db}"

    child_pid = fork do
      Dir.chdir(Dir.pwd)
      system({"PGPASSWORD" => "#{password}"}, command)
      puts "[Backup] - Did backup!"
      exit
    end
    Process.wait

    object_store = ObjectStore::AmazonS3ObjectStore.new(bucket_name: 'nilus-db-backups', base_path: 'production')
    object_store.upload_file(folder: 'logistic', file_name: outputFile, file_local_path: outputFile)
    puts "[Backup] - Uploaded to S3"
    File.delete(outputFile)
    puts "[Backup] - Deleted local file"

    render json: { message: "Ok"}, status: :ok
  end

  private

  def authorize
    token_matches = Rails.application.secrets.job_token == permitted_params[:token]
    render json: { message: 'Unauthorized' }, status: :unauthorized unless token_matches
  end

  def cancel_payment_params
    params.permit(:payment_id)
  end

  def permitted_params
    params.permit(:token)
  end
end
