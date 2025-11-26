class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  def index
    @q = Project.ransack(params[:q])
    @pagy, @projects = pagy(@q.result, items: 10)
  end

  def show
  end

  def new
    @project = Project.new
    @clients = Client.all
    @users = User.all
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      redirect_to @project, notice: 'Proyecto creado exitosamente.'
    else
      @clients = Client.all
      @users = User.all
      render :new
    end
  end

  def edit
    @clients = Client.all
    @users = User.all
  end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: 'Proyecto actualizado exitosamente.'
    else
      @clients = Client.all
      @users = User.all
      render :edit
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_url, notice: 'Proyecto eliminado exitosamente.'
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:folio_number, :name, :description, :client_id, :responsible_id, :location, :project_type, :status, :start_date, :estimated_end_date, :actual_end_date, attachments_attributes: [:id, :file, :file_description, :_destroy])
  end
end
