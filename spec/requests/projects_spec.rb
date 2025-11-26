require 'rails_helper'

RSpec.describe "Projects", type: :request do
  before do
    @user = create(:user)
    post user_session_path, params: { user: { login: @user.username, password: @user.password } }
  end

  describe "GET /projects" do
    it "returns http success" do
      get projects_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /projects/:id" do
    it "returns http success" do
      client = create(:client)
      project = create(:project, client: client, responsible: @user)
      get project_path(project)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /projects/new" do
    it "returns http success" do
      get new_project_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /projects" do
    it "creates a new project" do
      client = create(:client)

      expect {
        post projects_path, params: {
          project: {
            folio_number: 'PF-002',
            name: 'New Project',
            description: 'Project Description',
            client_id: client.id,
            responsible_id: @user.id,
            project_type: :construction,
            start_date: Date.current
          }
        }
      }.to change(Project, :count).by(1)

      expect(response).to have_http_status(:redirect)
    end
  end

  describe "GET /projects/:id/edit" do
    it "returns http success" do
      client = create(:client)
      project = create(:project, client: client, responsible: @user)
      get edit_project_path(project)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /projects/:id" do
    it "updates the project" do
      client = create(:client)
      project = create(:project, client: client, responsible: @user)

      patch project_path(project), params: {
        project: {
          name: 'Updated Project Name'
        }
      }

      expect(response).to have_http_status(:redirect)
      project.reload
      expect(project.name).to eq('Updated Project Name')
    end
  end

  describe "DELETE /projects/:id" do
    it "destroys the project" do
      client = create(:client)
      project = create(:project, client: client, responsible: @user)

      expect {
        delete project_path(project)
      }.to change(Project, :count).by(-1)

      expect(response).to have_http_status(:redirect)
    end
  end
end
