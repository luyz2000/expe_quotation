class MaterialsController < ApplicationController
  before_action :set_material, only: [ :show, :edit, :update, :destroy ]
  load_and_authorize_resource

  def index
    @q = Material.ransack(params[:q])
    @pagy, @materials = pagy(@q.result, items: 10)
  end

  def show
  end

  def new
    @material = Material.new
  end

  def create
    @material = Material.new(material_params)
    if @material.save
      redirect_to @material, notice: "Material creado exitosamente."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @material.update(material_params)
      redirect_to @material, notice: "Material actualizado exitosamente."
    else
      render :edit
    end
  end

  def destroy
    @material.destroy
    redirect_to materials_url, notice: "Material eliminado exitosamente."
  end

  private

  def set_material
    @material = Material.find(params[:id])
  end

  def material_params
    params.require(:material).permit(:code, :title, :description, :unit, :cost_price, :public_price, :category)
  end
end
