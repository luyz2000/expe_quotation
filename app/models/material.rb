class Material < ApplicationRecord
  enum :unit, { piece: 0, meter: 1, kg: 2, liter: 3, unit: 4 }, validate: true
  enum :category, { electric: 0, mechanical: 1, tools: 2, safety: 3, other: 4 }, validate: true

  has_paper_trail

  def self.ransackable_attributes(auth_object = nil)
    ["category", "code", "cost_price", "created_at", "description", "id", "public_price", "title", "unit", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["versions"]
  end
end

# == Schema Information
#
# Table name: materials
#
#  id           :bigint           not null, primary key
#  category     :integer          default("electric")
#  code         :string           not null
#  cost_price   :decimal(10, 2)   default(0.0)
#  description  :text
#  public_price :decimal(10, 2)   default(0.0)
#  title        :string           not null
#  unit         :integer          default("piece")
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
