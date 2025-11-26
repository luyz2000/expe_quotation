class QuotationItem < ApplicationRecord
  # Disable STI by setting inheritance column to nil since 'type' is used for our enum
  self.inheritance_column = :_type_disabled

  belongs_to :quotation

  attribute :item_type, :integer
  enum :item_type, { material: 0, service: 1 }, validate: true
  enum :unit, { piece: 0, meter: 1, hour: 2, kg: 3 }, validate: true
  enum :currency, { MXN: 0, USD: 1 }, validate: true

  has_paper_trail
end

# == Schema Information
#
# Table name: quotation_items
#
#  id           :bigint           not null, primary key
#  amount       :decimal(10, 2)   default(0.0)
#  currency     :integer          default("MXN")
#  description  :text             not null
#  quantity     :decimal(8, 2)    default(0.0)
#  type         :integer          default(0)
#  unit         :integer          default("piece")
#  unit_price   :decimal(10, 2)   default(0.0)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  quotation_id :bigint           not null, indexed
#
# Indexes
#
#  index_quotation_items_on_quotation_id  (quotation_id)
#
# Foreign Keys
#
#  fk_rails_...  (quotation_id => quotations.id)
#
