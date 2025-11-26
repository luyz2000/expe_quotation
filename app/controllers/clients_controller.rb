class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  def index
    @q = Client.ransack(params[:q])
    @pagy, @clients = pagy(@q.result, items: 10)
  end

  def show
  end

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(client_params)
    if @client.save
      redirect_to @client, notice: 'Cliente creado exitosamente.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @client.update(client_params)
      redirect_to @client, notice: 'Cliente actualizado exitosamente.'
    else
      render :edit
    end
  end

  def destroy
    @client.destroy
    redirect_to clients_url, notice: 'Cliente eliminado exitosamente.'
  end

  private

  def set_client
    @client = Client.find(params[:id])
  end

  def client_params
    params.require(:client).permit(:company_name, :tax_id, :contact_name, :contact_email, :contact_phone, :address, :city, :state, :client_type)
  end
end