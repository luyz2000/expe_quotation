require 'prawn'
require 'prawn/table'

# Suppress Prawn internationalization warning
Prawn::Fonts::AFM.hide_m17n_warning = true

class CoverPagePdf
  def initialize(company_info = {})
    @company_info = company_info
  end

  def render_cover(pdf, quotation)
    # This method is kept for backward compatibility but not used with the new implementation
    # that uses the pre-existing cover.pdf file
    pdf.bounding_box([pdf.bounds.left, pdf.bounds.top - 50], width: pdf.bounds.width, height: pdf.bounds.height - 100) do
      # Add company logo if it exists
      begin
        pdf.image "#{Rails.root}/app/assets/images/logo.png", at: [200, pdf.bounds.top - 80], width: 200 if File.exist?("#{Rails.root}/app/assets/images/logo.png")
      rescue
        # If logo doesn't load, just continue
      end

      # Add company information
      pdf.move_down 120
      pdf.text @company_info[:name] || "Engineering Company", align: :center, size: 20, style: :bold
      pdf.text @company_info[:address], align: :center if @company_info[:address]
      pdf.text "#{@company_info[:city]}, #{@company_info[:state]}", align: :center if @company_info[:city] && @company_info[:state]
      pdf.text @company_info[:contact], align: :center if @company_info[:contact]

      pdf.move_down 40
      pdf.text "COTIZACIÓN", align: :center, size: 24, style: :bold, color: '0000FF'
      pdf.move_down 20
      pdf.text "Cotización ##{quotation.quotation_number}", align: :center, size: 16
      pdf.move_down 10
      pdf.text "Fecha de Emisión: #{quotation.publish_date}", align: :center
      pdf.move_down 20
      pdf.text "Fecha de Vencimiento: #{quotation.expiry_date}", align: :center

      pdf.move_down 40
      pdf.text "Cliente:", style: :bold
      pdf.text quotation.client&.company_name
      pdf.text quotation.client&.address if quotation.client&.address
      pdf.text "#{quotation.client&.city}, #{quotation.client&.state}" if quotation.client&.city || quotation.client&.state
    end

    pdf.start_new_page
  end
end