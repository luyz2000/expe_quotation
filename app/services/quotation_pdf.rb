class QuotationPdf
  def initialize(quotation)
    @quotation = quotation
    @pdf = Prawn::Document.new
    generate
  end

  def generate
    header
    quotation_info
    items_table
    totals
    terms_and_conditions
  end

  def render
    @pdf.render
  end

  private

  def header
    @pdf.bounding_box([0, @pdf.cursor], width: @pdf.bounds.width) do
      @pdf.text "EXPE INGENIERÍA APLICADA", size: 16, style: :bold, align: :center
      @pdf.text "Cotización", size: 14, style: :bold, align: :center
      @pdf.move_down 10
    end
  end

  def quotation_info
    @pdf.bounding_box([0, @pdf.cursor], width: @pdf.bounds.width) do
      # Customer information
      @pdf.text "Cliente:", style: :bold
      @pdf.text @quotation.client&.razon_social.to_s
      @pdf.text @quotation.client&.direccion.to_s
      @pdf.text "RFC: #{@quotation.client&.rfc}"
      @pdf.move_down 10

      # Quotation details
      @pdf.text "Datos de la Cotización:", style: :bold
      @pdf.move_down 5
      @pdf.table([
        ["Número de Cotización:", @quotation.numero_cotizacion],
        ["Fecha de Emisión:", @quotation.publish_date&.strftime("%d/%m/%Y")],
        ["Fecha de Vencimiento:", @quotation.fecha_vencimiento&.strftime("%d/%m/%Y")],
        ["Vendedor:", @quotation.salesperson&.name],
        ["Tipo de Proyecto:", @quotation.project_type&.humanize]
      ], cell_style: { border_width: 0, padding: [2, 5] })
      @pdf.move_down 10
    end
  end

  def items_table
    @pdf.bounding_box([0, @pdf.cursor], width: @pdf.bounds.width) do
      @pdf.text "Conceptos:", style: :bold
      @pdf.move_down 5

      # Table header
      headers = ["Tipo", "Descripción", "Cant.", "Unidad", "Precio Unit.", "Importe"]
      data = [headers]

      # Add items
      @quotation.quotation_items.each do |item|
        data << [
          item.tipo&.humanize,
          item.descripcion,
          item.cantidad.to_s,
          item.unidad&.humanize,
          number_to_currency(item.precio_unitario),
          number_to_currency(item.importe)
        ]
      end

      # Create the table
      @pdf.table(data, header: true, cell_style: { align: :center }) do |t|
        t.columns(1).align = :left
        t.columns(5).align = :right
        t.row(0).font_style = :bold
      end

      @pdf.move_down 10
    end
  end

  def totals
    @pdf.bounding_box([0, @pdf.cursor], width: @pdf.bounds.width) do
      # Add totals table
      totals_data = [
        ["Subtotal:", number_to_currency(@quotation.subtotal)],
        ["Total:", number_to_currency(@quotation.total)]
      ]

      @pdf.table(totals_data, cell_style: { border_width: 0, padding: [2, 5] }) do |t|
        t.columns(1).align = :right
        t.row(0).font_style = :bold
        t.row(1).font_style = :bold
      end

      @pdf.move_down 10
    end
  end

  def terms_and_conditions
    if @quotation.terminos_condiciones.present?
      @pdf.text "Términos y Condiciones:", style: :bold
      @pdf.text @quotation.terminos_condiciones
    end
  end

  def number_to_currency(number)
    return "0.00" if number.blank?
    format("$%.2f", number)
  end
end