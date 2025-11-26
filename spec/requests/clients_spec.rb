require 'rails_helper'

RSpec.describe "Clients", type: :request do
  before do
    @user = create(:user)
    post user_session_path, params: { user: { login: @user.username, password: @user.password } }
  end

  describe "GET /clients" do
    it "returns http success" do
      get clients_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /clients/:id" do
    it "returns http success" do
      client = create(:client)
      get client_path(client)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /clients/new" do
    it "returns http success" do
      get new_client_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /clients" do
    it "creates a new client" do
      expect {
        post clients_path, params: {
          client: {
            company_name: 'New Client Company',
            tax_id: 'TAX123456',
            contact_name: 'John Doe',
            contact_email: 'john@example.com',
            contact_phone: '555-1234'
          }
        }
      }.to change(Client, :count).by(1)

      expect(response).to have_http_status(:redirect)
    end
  end

  describe "GET /clients/:id/edit" do
    it "returns http success" do
      client = create(:client)
      get edit_client_path(client)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /clients/:id" do
    it "updates the client" do
      client = create(:client)

      patch client_path(client), params: {
        client: {
          company_name: 'Updated Client Name'
        }
      }

      expect(response).to have_http_status(:redirect)
      client.reload
      expect(client.company_name).to eq('Updated Client Name')
    end
  end

  describe "DELETE /clients/:id" do
    it "destroys the client" do
      client = create(:client)

      expect {
        delete client_path(client)
      }.to change(Client, :count).by(-1)

      expect(response).to have_http_status(:redirect)
    end
  end
end
