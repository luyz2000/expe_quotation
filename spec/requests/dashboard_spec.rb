require 'rails_helper'

RSpec.describe "Dashboards", type: :request do
  before do
    @user = create(:user, password: 'password123')
    post user_session_path, params: { user: { login: @user.username, password: 'password123' } }
  end

  describe "GET /dashboard/index" do
    it "returns http success" do
      get dashboard_index_path
      expect(response).to have_http_status(:success)
    end
  end

end
