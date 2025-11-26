class Project < ApplicationRecord
  belongs_to :client
  belongs_to :responsible, class_name: 'User', foreign_key: 'responsible_id'

  enum :project_type, { construction: 0, installation: 1, modification: 2 }, validate: true
  enum :status, { planned: 0, accepted: 1, in_progress: 2, completed: 3, cancelled: 4 }, validate: true

  has_many :quotations, dependent: :nullify
  has_many :attachments, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  has_paper_trail

  after_update :send_completed_notification, if: -> { saved_change_to_status? && status == 'completed' }

  def self.ransackable_attributes(auth_object = nil)
    ["actual_end_date", "attachments", "client_id", "created_at", "description", "estimated_end_date", "folio_number", "id", "location", "name", "project_type", "start_date", "status", "updated_at", "user_id"]
  end

  private

  

  def send_completed_notification
    NotificationService.send_project_completed_notification(self)
  end
end

# == Schema Information
#
# Table name: projects
#
#  id                 :bigint           not null, primary key
#  actual_end_date    :date
#  description        :text
#  estimated_end_date :date
#  folio_number       :string           not null
#  location           :text
#  name               :string           not null
#  project_type       :integer          default("construction")
#  start_date         :date
#  status             :integer          default("planned")
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  client_id          :bigint           not null, indexed
#  responsible_id     :bigint
#
# Indexes
#
#  index_projects_on_client_id  (client_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#
