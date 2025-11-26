class PublicController < ApplicationController
  # Skip authentication for public endpoints
  skip_before_action :authenticate_user!
  # Skip authorization checks for public endpoints
  skip_before_action :verify_authenticity_token, only: [:qr_image]

  def show_qr
    @quotation = Quotation.find_by(id: params[:id])

    if @quotation
      # Generate QR code with the public URL for this quotation
      public_url = public_quotation_url(@quotation.id)
      @qr_code = RQRCode::QRCode.new(public_url)

      # Generate the QR code in a suitable format for display
      @qr_code_svg = @qr_code.as_svg(
        offset: 0,
        color: '000',
        shape_rendering: 'crispEdges',
        module_size: 6,
        standalone: true
      )
    else
      render plain: "Quotation not found", status: :not_found
    end
  end

  def qr_image
    @quotation = Quotation.find_by(id: params[:id])

    if @quotation
      # Generate QR code with the public URL for this quotation
      public_url = public_quotation_url(@quotation.id)
      @qr_code = RQRCode::QRCode.new(public_url)

      # Respond with PNG image
      svg_string = @qr_code.as_svg(
        offset: 0,
        color: '000',
        shape_rendering: 'crispEdges',
        module_size: 6,
        standalone: true
      )

      # Convert SVG to PNG (you might want to use a gem like 'chunky_png' or 'mini_magick' for this)
      # For now, let's respond with the SVG as an alternative
      send_data svg_string, type: 'image/svg+xml', disposition: 'inline'
    else
      render plain: "Quotation not found", status: :not_found
    end
  end

  def public_quotation
    @quotation = Quotation.includes(:quotation_items, :client, :project).find_by(id: params[:id])

    if @quotation
      # Allow public access to quotation data - this should be limited for security
      # Only show essential information in public view
      # This view will be visible to anyone with the link
    else
      render plain: "Quotation not found", status: :not_found
    end
  end
end
