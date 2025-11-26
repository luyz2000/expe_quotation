require 'rails_helper'

RSpec.describe "Homes", type: :request do
  before do
    @user = create(:user, password: 'password123')
    post user_session_path, params: { user: { login: @user.username, password: 'password123' } }
  end

  describe "GET /home/index" do
    it "redirects to clients path when user is signed in" do
      get home_index_path
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(clients_path)
    end
  end

end
