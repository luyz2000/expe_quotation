require 'rails_helper'

RSpec.describe "QuotationItems", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/quotation_items/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/quotation_items/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/quotation_items/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/quotation_items/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/quotation_items/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
