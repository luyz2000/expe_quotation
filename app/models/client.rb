class Client < ApplicationRecord
  enum :client_type, { residential: 0, industrial: 1, governmental: 2 }, validate: true

  has_many :projects, dependent: :nullify
  has_many :quotations, dependent: :nullify

  has_paper_trail

  def self.ransackable_attributes(auth_object = nil)
    ["address", "city", "client_type", "company_name", "contact_email", "contact_name", "contact_phone", "created_at", "id", "id_value", "state", "tax_id", "updated_at"]
  end
end

# == Schema Information
#
# Table name: clients
#
#  id            :bigint           not null, primary key
#  address       :text
#  city          :string
#  client_type   :integer          default("residential")
#  company_name  :string           not null
#  contact_email :string
#  contact_name  :string
#  contact_phone :string
#  state         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  tax_id        :string
#
