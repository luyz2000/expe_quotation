require 'rails_helper'

RSpec.describe "Reports", type: :request do
  describe "GET /quotation_pdf" do
    it "returns http success" do
      get "/reports/quotation_pdf"
      expect(response).to have_http_status(:success)
    end
  end

end
