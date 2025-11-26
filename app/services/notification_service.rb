class NotificationService
  def self.send_new_quotation_notification(quotation)
    begin
      # Check if we're in a context where Sidekiq is available
      if defined?(Sidekiq) && (Rails.env.production? || Rails.env.development?)
        # Notify salesperson
        NotificationWorker.perform_async('new_quotation', quotation.salesperson.id, quotation.id) if quotation.salesperson

        # Notify admin users
        User.admin.each do |admin|
          NotificationWorker.perform_async('new_quotation', admin.id, quotation.id)
        end
      else
        # For seeding or testing, send directly
        NotificationMailer.new_quotation_email(quotation.salesperson, quotation).deliver_now if quotation.salesperson

        User.admin.each do |admin|
          NotificationMailer.new_quotation_email(admin, quotation).deliver_now
        end
      end
    rescue RedisClient::CannotConnectError, Errno::ECONNREFUSED => e
      # If Redis/Sidekiq is not available, send directly
      NotificationMailer.new_quotation_email(quotation.salesperson, quotation).deliver_now if quotation.salesperson

      User.admin.each do |admin|
        NotificationMailer.new_quotation_email(admin, quotation).deliver_now
      end
    rescue => e
      Rails.logger.error "Failed to send new quotation notification: #{e.message}"
      # Still try to send directly as fallback
      begin
        NotificationMailer.new_quotation_email(quotation.salesperson, quotation).deliver_now if quotation.salesperson
        User.admin.each do |admin|
          NotificationMailer.new_quotation_email(admin, quotation).deliver_now
        end
      rescue => fallback_error
        Rails.logger.error "Fallback notification also failed: #{fallback_error.message}"
      end
    end
  end

  def self.send_quotation_approved_notification(quotation)
    begin
      # Check if we're in a context where Sidekiq is available
      if defined?(Sidekiq) && (Rails.env.production? || Rails.env.development?)
        # Notify salesperson
        NotificationWorker.perform_async('quotation_approved', quotation.salesperson.id, quotation.id) if quotation.salesperson
      else
        # For seeding or testing, send directly
        NotificationMailer.quotation_approved_email(quotation.salesperson, quotation).deliver_now if quotation.salesperson
      end
    rescue RedisClient::CannotConnectError, Errno::ECONNREFUSED => e
      # If Redis/Sidekiq is not available, send directly
      NotificationMailer.quotation_approved_email(quotation.salesperson, quotation).deliver_now if quotation.salesperson
    rescue => e
      Rails.logger.error "Failed to send quotation approved notification: #{e.message}"
      # Still try to send directly as fallback
      begin
        NotificationMailer.quotation_approved_email(quotation.salesperson, quotation).deliver_now if quotation.salesperson
      rescue => fallback_error
        Rails.logger.error "Fallback notification also failed: #{fallback_error.message}"
      end
    end
  end

  def self.send_quotation_rejected_notification(quotation)
    begin
      # Check if we're in a context where Sidekiq is available
      if defined?(Sidekiq) && (Rails.env.production? || Rails.env.development?)
        # Notify salesperson
        NotificationWorker.perform_async('quotation_rejected', quotation.salesperson.id, quotation.id) if quotation.salesperson
      else
        # For seeding or testing, send directly
        NotificationMailer.quotation_rejected_email(quotation.salesperson, quotation).deliver_now if quotation.salesperson
      end
    rescue RedisClient::CannotConnectError, Errno::ECONNREFUSED => e
      # If Redis/Sidekiq is not available, send directly
      NotificationMailer.quotation_rejected_email(quotation.salesperson, quotation).deliver_now if quotation.salesperson
    rescue => e
      Rails.logger.error "Failed to send quotation rejected notification: #{e.message}"
      # Still try to send directly as fallback
      begin
        NotificationMailer.quotation_rejected_email(quotation.salesperson, quotation).deliver_now if quotation.salesperson
      rescue => fallback_error
        Rails.logger.error "Fallback notification also failed: #{fallback_error.message}"
      end
    end
  end

  def self.send_project_completed_notification(project)
    begin
      # Check if we're in a context where Sidekiq is available
      if defined?(Sidekiq) && (Rails.env.production? || Rails.env.development?)
        # Notify responsible
        NotificationWorker.perform_async('project_completed', project.responsible.id, project.id) if project.responsible

        # Notify admin users
        User.admin.each do |admin|
          NotificationWorker.perform_async('project_completed', admin.id, project.id)
        end
      else
        # For seeding or testing, send directly
        NotificationMailer.project_completed_email(project.responsible, project).deliver_now if project.responsible

        User.admin.each do |admin|
          NotificationMailer.project_completed_email(admin, project).deliver_now
        end
      end
    rescue RedisClient::CannotConnectError, Errno::ECONNREFUSED => e
      # If Redis/Sidekiq is not available, send directly
      NotificationMailer.project_completed_email(project.responsible, project).deliver_now if project.responsible

      User.admin.each do |admin|
        NotificationMailer.project_completed_email(admin, project).deliver_now
      end
    rescue => e
      Rails.logger.error "Failed to send project completed notification: #{e.message}"
      # Still try to send directly as fallback
      begin
        NotificationMailer.project_completed_email(project.responsible, project).deliver_now if project.responsible

        User.admin.each do |admin|
          NotificationMailer.project_completed_email(admin, project).deliver_now
        end
      rescue => fallback_error
        Rails.logger.error "Fallback notification also failed: #{fallback_error.message}"
      end
    end
  end
end