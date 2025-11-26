class NotificationMailer < ApplicationMailer
  default from: "noreply@constructoraexpe.com"
  layout "mailer"

  def new_quotation_email(user, quotation)
    @user = user
    @quotation = quotation
    @url = quotation_url(@quotation)
    mail(to: @user.email, subject: "New quotation created - #{@quotation.quotation_number}")
  end

  def quotation_approved_email(user, quotation)
    @user = user
    @quotation = quotation
    @url = quotation_url(@quotation)
    mail(to: @user.email, subject: "Quotation approved - #{@quotation.quotation_number}")
  end

  def quotation_rejected_email(user, quotation)
    @user = user
    @quotation = quotation
    @url = quotation_url(@quotation)
    mail(to: @user.email, subject: "Quotation rejected - #{@quotation.quotation_number}")
  end

  def project_completed_email(user, project)
    @user = user
    @project = project
    @url = project_url(@project)
    mail(to: @user.email, subject: "Proyecto completado - #{@project.name}")
  end
end
