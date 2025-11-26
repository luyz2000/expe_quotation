class NotificationWorker
  include Sidekiq::Worker

  def perform(notification_type, user_id, record_id)
    user = User.find(user_id)
    case notification_type
    when 'new_quotation'
      quotation = Quotation.find(record_id)
      NotificationMailer.new_quotation_email(user, quotation).deliver_now
    when 'quotation_approved'
      quotation = Quotation.find(record_id)
      NotificationMailer.quotation_approved_email(user, quotation).deliver_now
    when 'quotation_rejected'
      quotation = Quotation.find(record_id)
      NotificationMailer.quotation_rejected_email(user, quotation).deliver_now
    when 'project_completed'
      project = Project.find(record_id)
      NotificationMailer.project_completed_email(user, project).deliver_now
    end
  end
end