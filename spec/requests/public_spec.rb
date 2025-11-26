require 'rails_helper'

RSpec.describe "Publics", type: :request do
  describe "GET /show_qr" do
    it "returns http success when quotation exists" do
      user = create(:user)
      client = create(:client)
      project = create(:project, client: client, responsible: user)
      quotation = create(:quotation, client: client, project: project, salesperson: user)

      get "/public/show_qr/#{quotation.id}"
      expect(response).to have_http_status(:success)
    end

    it "returns not found when quotation does not exist" do
      get "/public/show_qr/99999"
      expect(response).to have_http_status(:not_found)
    end
  end
end
