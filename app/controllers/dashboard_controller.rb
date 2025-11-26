class DashboardController < ApplicationController
  def index
    # Dashboard statistics
    @total_quotations = Quotation.count
    @total_projects = Project.count
    @projects_in_progress = Project.in_progress.count
    @quotations_approved = Quotation.approved.count

    # Monthly revenue calculation
    @monthly_revenue = calculate_monthly_revenue

    # Data for charts
    @quotations_by_status = Quotation.group(:status).count
    @projects_by_type = Project.group(:project_type).count
    @quotations_by_month = Quotation.where.not(publish_date: nil).group("DATE_TRUNC('month', publish_date)").size
  end

  private

  def calculate_monthly_revenue
    # Calculate revenue for the current month
    start_of_month = Date.current.beginning_of_month
    end_of_month = Date.current.end_of_month
    Quotation.approved
             .where(publish_date: start_of_month..end_of_month)
             .sum(:total)
  end
end
