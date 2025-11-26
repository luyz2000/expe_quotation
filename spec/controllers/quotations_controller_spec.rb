require 'rails_helper'

RSpec.describe QuotationsController, type: :controller do
  before do
    @user = create(:user, email: 'test@example.com', username: 'testuser', password: 'password123')
    request.env["warden"].set_user(@user)  # Set user in Warden for controller tests
  end

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      client = create(:client, company_name: 'Test Client')
      project = create(:project, folio_number: 'FOL-001', name: 'Test Project', client: client, responsible: @user)
      quotation = create(:quotation,
        quotation_number: 'QT-001',
        project: project,
        client: client,
        salesperson: @user,
        project_type: :high_voltage,
        status: :draft,
        subtotal: 1000.00,
        total: 1000.00
      )

      get :show, params: { id: quotation.to_param }
      expect(response).to be_successful
    end
  end
end