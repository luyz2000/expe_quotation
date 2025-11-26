class QuotationsController < ApplicationController
  before_action :set_quotation, only: [:show, :edit, :update, :destroy, :approve, :reject, :send_for_approval]
  load_and_authorize_resource

  def index
    @q = Quotation.ransack(params[:q])
    @pagy, @quotations = pagy(@q.result, items: 10)
  end

  def show
    @quotation_items = @quotation.quotation_items
  end

  def new
    @quotation = Quotation.new
    @projects = Project.all
    @clients = Client.all
    @users = User.where(role: ['salesperson', 'admin'])
  end

  def create
    @quotation = Quotation.new(quotation_params)
    @quotation.salesperson = current_user if @quotation.salesperson.blank?
    if @quotation.save
      redirect_to @quotation, notice: 'Cotización creada exitosamente.'
    else
      @projects = Project.all
      @clients = Client.all
      @users = User.where(role: ['salesperson', 'admin'])
      render :new
    end
  end

  def edit
    @projects = Project.all
    @clients = Client.all
    @users = User.where(role: ['salesperson', 'admin'])
  end

  def update
    if @quotation.update(quotation_params)
      redirect_to @quotation, notice: 'Cotización actualizada exitosamente.'
    else
      @projects = Project.all
      @clients = Client.all
      @users = User.where(role: ['salesperson', 'admin'])
      render :edit
    end
  end

  def destroy
    @quotation.destroy
    redirect_to quotations_url, notice: 'Cotización eliminada exitosamente.'
  end

  def approve
    @quotation.update(status: 'approved')
    redirect_to @quotation, notice: 'Cotización aprobada exitosamente.'
  end

  def reject
    @quotation.update(status: 'rejected')
    redirect_to @quotation, notice: 'Cotización rechazada exitosamente.'
  end

  def send_for_approval
    @quotation.update(status: 'sent')
    redirect_to @quotation, notice: 'Cotización enviada para aprobación.'
  end

  def download_pdf
    @quotation = Quotation.find(params[:id])
    respond_to do |format|
      format.pdf do
        pdf = QuotationPdf.new(@quotation)
        send_data pdf.render, filename: "quotation_#{@quotation.quotation_number}.pdf",
                              type: 'application/pdf',
                              disposition: 'attachment'
      end
    end
  end

  private

  def set_quotation
    @quotation = Quotation.find(params[:id])
  end

  def quotation_params
    params.require(:quotation).permit(:quotation_number, :project_id, :client_id, :salesperson_id, :project_type, :publish_date, :expiry_date, :subtotal, :total, :status, :terms_conditions, :notes, :revision_number, attachments_attributes: [:id, :file, :file_description, :_destroy])
  end
end
