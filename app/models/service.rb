class Service < ApplicationRecord
  enum :unit, { hour: 0, service: 1, shift: 2, project: 3, unit: 4 }, validate: true
  enum :category, { installation: 0, maintenance: 1, consulting: 2, other: 3 }, validate: true

  has_paper_trail

  def self.ransackable_attributes(auth_object = nil)
    ["category", "code", "created_at", "description", "id", "public_price", "suggested_price", "title", "unit", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["versions"]
  end
end

# == Schema Information
#
# Table name: services
#
#  id              :bigint           not null, primary key
#  category        :integer          default("installation")
#  code            :string           not null
#  description     :text
#  public_price    :decimal(10, 2)   default(0.0)
#  suggested_price :decimal(10, 2)   default(0.0)
#  title           :string           not null
#  unit            :integer          default("hour")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
