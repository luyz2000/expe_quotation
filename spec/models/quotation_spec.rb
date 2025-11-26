require 'rails_helper'

RSpec.describe Quotation, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      # Create associated records first
      client = Client.create!(company_name: 'Test Client')
      responsible_user = User.create!(email: 'responsible@example.com', username: 'responsible', password: 'password123', name: 'Responsible', last_name: 'User', role: :engineer, status: :active)
      project = Project.create!(folio_number: 'FOL-001', name: 'Test Project', client: client, responsible: responsible_user)
      user = User.create!(email: 'test@example.com', username: 'testuser', password: 'password123', name: 'Test', last_name: 'User', role: :salesperson, status: :active)

      quotation = Quotation.new(
        quotation_number: 'QT-001',
        project: project,
        client: client,
        salesperson: user,
        project_type: :high_voltage,
        status: :draft,
        subtotal: 1000.00,
        total: 1000.00
      )
      expect(quotation).to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to a project' do
      quotation = Quotation.reflect_on_association(:project)
      expect(quotation.macro).to eq(:belongs_to)
    end

    it 'belongs to a client' do
      quotation = Quotation.reflect_on_association(:client)
      expect(quotation.macro).to eq(:belongs_to)
    end

    it 'belongs to a salesperson' do
      quotation = Quotation.reflect_on_association(:salesperson)
      expect(quotation.macro).to eq(:belongs_to)
    end

    it 'has many quotation_items' do
      quotation = Quotation.reflect_on_association(:quotation_items)
      expect(quotation.macro).to eq(:has_many)
    end
  end

  describe 'enums' do
    it 'has correct project_type values' do
      expect(Quotation.project_types.keys).to include('high_voltage', 'low_voltage', 'automation')
    end

    it 'has correct status values' do
      expect(Quotation.statuses.keys).to include('draft', 'sent', 'approved', 'rejected', 'cancelled')
    end
  end
end