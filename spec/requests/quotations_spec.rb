require 'rails_helper'

RSpec.describe "Quotations", type: :request do
  before do
    @user = create(:user)
    post user_session_path, params: { user: { login: @user.username, password: @user.password } }
  end

  describe "GET /quotations" do
    it "returns http success" do
      get quotations_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /quotations/:id" do
    it "returns http success" do
      client = create(:client)
      project = create(:project, client: client, responsible: @user)
      quotation = create(:quotation, client: client, project: project, salesperson: @user)

      get quotation_path(quotation)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /quotations/new" do
    it "returns http success" do
      get new_quotation_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /quotations" do
    it "creates a new quotation" do
      client = create(:client)
      project = create(:project, client: client, responsible: @user)

      expect {
        post quotations_path, params: {
          quotation: {
            quotation_number: 'QT-002',
            project_id: project.id,
            client_id: client.id,
            salesperson_id: @user.id,
            project_type: :high_voltage,
            publish_date: Date.current,
            expiry_date: Date.current + 30.days,
            subtotal: 1000.00,
            total: 1200.00,
            status: :draft
          }
        }
      }.to change(Quotation, :count).by(1)

      expect(response).to have_http_status(:redirect)
    end
  end

  describe "GET /quotations/:id/edit" do
    it "returns http success" do
      client = create(:client)
      project = create(:project, client: client, responsible: @user)
      quotation = create(:quotation, client: client, project: project, salesperson: @user)

      get edit_quotation_path(quotation)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /quotations/:id" do
    it "updates the quotation" do
      client = create(:client)
      project = create(:project, client: client, responsible: @user)
      quotation = create(:quotation, client: client, project: project, salesperson: @user)

      patch quotation_path(quotation), params: {
        quotation: {
          quotation_number: 'QT-002-UPDATE'
        }
      }

      expect(response).to have_http_status(:redirect)
      quotation.reload
      expect(quotation.quotation_number).to eq('QT-002-UPDATE')
    end
  end

  describe "DELETE /quotations/:id" do
    it "destroys the quotation" do
      client = create(:client)
      project = create(:project, client: client, responsible: @user)
      quotation = create(:quotation, client: client, project: project, salesperson: @user)

      expect {
        delete quotation_path(quotation)
      }.to change(Quotation, :count).by(-1)

      expect(response).to have_http_status(:redirect)
    end
  end
end
