class Quotation < ApplicationRecord
  belongs_to :project
  belongs_to :client
  belongs_to :salesperson, class_name: 'User', foreign_key: 'salesperson_id'

  enum :project_type, { high_voltage: 0, low_voltage: 1, automation: 2 }, validate: true
  enum :status, { draft: 0, sent: 1, approved: 2, rejected: 3, cancelled: 4 }, validate: true

  has_many :quotation_items, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  has_paper_trail

  after_create :send_new_quotation_notification
  after_update :send_status_change_notification, if: :saved_change_to_status?

  def self.ransackable_attributes(auth_object = nil)
    ["attachments", "client_id", "created_at", "expiry_date", "id", "publish_date", "notes", "project_id", "project_type", "quotation_number", "revision_number", "status", "subtotal", "terms_conditions", "total", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["client", "project", "quotation_items", "salesperson", "versions"]
  end

  private

  def send_new_quotation_notification
    NotificationService.send_new_quotation_notification(self)
  end

  def send_status_change_notification
    case status
    when 'approved'
      NotificationService.send_quotation_approved_notification(self)
    when 'rejected'
      NotificationService.send_quotation_rejected_notification(self)
    end
  end
end

# == Schema Information
#
# Table name: quotations
#
#  id               :bigint           not null, primary key
#  expiry_date      :date
#  notes            :text
#  project_type     :integer          default("high_voltage")
#  publish_date     :date
#  quotation_number :string           not null
#  revision_number  :integer          default(0)
#  status           :integer          default("draft")
#  subtotal         :decimal(10, 2)   default(0.0)
#  terms_conditions :text
#  total            :decimal(10, 2)   default(0.0)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  client_id        :bigint           not null, indexed
#  project_id       :bigint           not null, indexed
#  salesperson_id   :bigint
#
# Indexes
#
#  index_quotations_on_client_id   (client_id)
#  index_quotations_on_project_id  (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#  fk_rails_...  (project_id => projects.id)
#
