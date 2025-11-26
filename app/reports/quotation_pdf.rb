require 'prawn'
require 'prawn/table'
require 'combine_pdf'

# Suppress Prawn internationalization warning
Prawn::Fonts::AFM.hide_m17n_warning = true

class QuotationPdf
  def initialize(quotation)
    @quotation = quotation
    @client = quotation.client
    @project = quotation.project
    @items = quotation.quotation_items
  end

  def render
    # Generate the Prawn content as a separate PDF
    prawn_pdf_content = Prawn::Document.new do |pdf|
      # Add quotation details page
      add_quotation_details(pdf)

      # Add quotation items table
      add_quotation_items(pdf)

      # Add terms and conditions
      add_terms_and_conditions(pdf)
    end.render

    # Load the existing cover PDF
    cover_pdf_path = Rails.root.join('app', 'views', 'shared', 'pdf', 'cover.pdf')

    # Create a new combined PDF
    combined_pdf = CombinePDF.new

    # Add the cover page if it exists
    if File.exist?(cover_pdf_path)
      cover = CombinePDF.load(cover_pdf_path)
      combined_pdf << cover
    else
      # Fallback: create a simple cover page if the cover.pdf doesn't exist
      fallback_cover = Prawn::Document.new do |cover_pdf|
        cover_pdf.bounding_box([cover_pdf.bounds.left, cover_pdf.bounds.top - 50],
                               width: cover_pdf.bounds.width,
                               height: cover_pdf.bounds.height - 100) do
          cover_pdf.move_down 150
          cover_pdf.text "COTIZACIÓN", align: :center, size: 24, style: :bold
          cover_pdf.move_down 20
          cover_pdf.text "Cotización ##{@quotation.quotation_number}", align: :center, size: 16
          cover_pdf.move_down 10
          cover_pdf.text "Fecha de Emisión: #{@quotation.publish_date}", align: :center
          cover_pdf.move_down 30

          cover_pdf.text "Cliente:", style: :bold
          cover_pdf.text @client.company_name
          cover_pdf.text @client.address if @client.address
          cover_pdf.text "#{@client.city}, #{@client.state}" if @client.city || @client.state
        end
        cover_pdf.start_new_page
      end
      fallback_cover_combined = CombinePDF.parse(fallback_cover.render)
      combined_pdf << fallback_cover_combined
    end

    # Add the main content PDF
    main_content = CombinePDF.parse(prawn_pdf_content)
    combined_pdf << main_content

    # Return the combined PDF as string
    combined_pdf.to_pdf
  end

  private

  def add_quotation_details(pdf)
    pdf.text "Detalles de la Cotización", align: :center, size: 18, style: :bold
    pdf.move_down 10

    # Create a table for quotation details
    data = [
      ["Número de Cotización", @quotation.quotation_number],
      ["Proyecto", @project.name],
      ["Cliente", @client.company_name],
      ["Vendedor", @quotation.salesperson&.name],
      ["Tipo de Proyecto", @quotation.project_type&.humanize],
      ["Fecha de Emisión", @quotation.publish_date],
      ["Fecha de Vencimiento", @quotation.expiry_date],
      ["Estado", @quotation.status&.humanize]
    ]

    pdf.table(data,
      column_widths: [150, 300],
      cell_style: { padding: 5 }
    ) do
      row(0).font_style = :bold
      cells.borders = [:left, :right, :top, :bottom]
      cells.border_width = 1
    end

    # Add subtotal and total
    pdf.move_down 10
    data_totals = [
      ["Subtotal", number_to_currency(@quotation.subtotal)],
      ["Total", number_to_currency(@quotation.total)]
    ]

    pdf.table(data_totals,
      column_widths: [300, 150],
      cell_style: { padding: 5, align: :right }
    ) do
      row(0).font_style = :bold
      row(1).font_style = :bold
      cells.borders = [:left, :right, :top, :bottom]
      cells.border_width = 1
    end

    pdf.start_new_page
  end

  def add_quotation_items(pdf)
    pdf.text "Conceptos de la Cotización", align: :center, size: 18, style: :bold
    pdf.move_down 10

    # Define table headers
    table_data = [
      ["#", "Tipo", "Descripción", "Cantidad", "Unidad", "Precio Unit.", "Importe"]
    ]

    # Add items to table
    @items.each_with_index do |item, index|
      table_data << [
        index + 1,
        item.item_type&.humanize,
        item.description,
        item.quantity,
        item.unit&.humanize,
        number_to_currency(item.unit_price),
        number_to_currency(item.amount)
      ]
    end

    # Calculate column widths to fit the page
    column_widths = [(pdf.bounds.width * 0.05).to_i,  # #
                     (pdf.bounds.width * 0.15).to_i,  # Tipo
                     (pdf.bounds.width * 0.30).to_i,  # Descripción
                     (pdf.bounds.width * 0.10).to_i,  # Cantidad
                     (pdf.bounds.width * 0.10).to_i,  # Unidad
                     (pdf.bounds.width * 0.15).to_i,  # Precio Unit.
                     (pdf.bounds.width * 0.15).to_i] # Importe

    # Create the table
    pdf.table(table_data, column_widths: column_widths) do
      row(0).font_style = :bold
      row(0).background_color = 'DDDDDD'
      cells.borders = [:left, :right, :top, :bottom]
      cells.border_width = 1
      cells.padding = 5
    end

    pdf.start_new_page
  end

  def add_terms_and_conditions(pdf)
    pdf.text "Términos y Condiciones", align: :center, size: 18, style: :bold
    pdf.move_down 10

    # Add terms and conditions if available
    if @quotation.terms_conditions.present?
      pdf.text @quotation.terms_conditions, align: :justify
    else
      pdf.text "No se especificaron términos y condiciones.", style: :italic
    end

    pdf.move_down 20

    # Add notes if available
    if @quotation.notes.present?
      pdf.text "Notas:", style: :bold
      pdf.text @quotation.notes, align: :justify
    end
  end

  def number_to_currency(number)
    # Format number as currency: $1,234.56
    formatted_number = number.to_f.round(2).to_s
    integer_part, decimal_part = formatted_number.split('.')
    integer_part = integer_part.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
    if decimal_part
      "$#{integer_part}.#{decimal_part}"
    else
      "$#{integer_part}"
    end
  end
end