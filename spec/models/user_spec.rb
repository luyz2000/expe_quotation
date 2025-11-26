require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = User.new(
        email: 'test@example.com',
        username: 'testuser',
        password: 'password123',
        name: 'Test',
        last_name: 'User',
        role: :salesperson,
        status: :active
      )
      expect(user).to be_valid
    end

    it 'is not valid without an email' do
      user = User.new(email: nil)
      expect(user).not_to be_valid
    end
  end

  describe 'associations' do
    it 'has many projects' do
      user = User.reflect_on_association(:projects)
      expect(user.macro).to eq(:has_many)
    end

    it 'has many quotations' do
      user = User.reflect_on_association(:quotations)
      expect(user.macro).to eq(:has_many)
    end
  end

  describe 'enums' do
    it 'has correct role values' do
      expect(User.roles).to include('admin', 'salesperson', 'engineer')
    end

    it 'has correct status values' do
      expect(User.statuses.keys).to include('inactive', 'active')
    end
  end
end