class QuotationItemsController < ApplicationController
  before_action :set_quotation
  before_action :set_quotation_item, only: [:edit, :update, :destroy]
  load_and_authorize_resource

  def new
    @quotation_item = @quotation.quotation_items.build
  end

  def create
    @quotation_item = @quotation.quotation_items.build(quotation_item_params)
    if @quotation_item.save
      # Recalculate totals
      recalculate_quotation_totals
      redirect_to @quotation, notice: 'Concepto agregado exitosamente.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @quotation_item.update(quotation_item_params)
      # Recalculate totals
      recalculate_quotation_totals
      redirect_to @quotation, notice: 'Concepto actualizado exitosamente.'
    else
      render :edit
    end
  end

  def destroy
    @quotation_item.destroy
    # Recalculate totals
    recalculate_quotation_totals
    redirect_to @quotation, notice: 'Concepto eliminado exitosamente.'
  end

  private

  def set_quotation
    @quotation = Quotation.find(params[:quotation_id])
  end

  def set_quotation_item
    @quotation_item = @quotation.quotation_items.find(params[:id])
  end

  def quotation_item_params
    params.require(:quotation_item).permit(:type, :description, :quantity, :unit, :unit_price, :amount, :currency)
  end

  def recalculate_quotation_totals
    subtotal = @quotation.quotation_items.sum(:amount)
    @quotation.update(subtotal: subtotal, total: subtotal)  # For now, total = subtotal; taxes could be added later
  end
end
