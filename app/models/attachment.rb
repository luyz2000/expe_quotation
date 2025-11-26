class Attachment < ApplicationRecord
  mount_uploader :file, AttachmentUploader

  belongs_to :attachable, polymorphic: true

  validates :original_filename, presence: true
  validates :file_size, presence: true, numericality: { greater_than: 0 }
  validates :file_type, presence: true
  validates :file, presence: true

  # Callbacks to update file metadata
  before_save :update_file_attributes

  private

  def update_file_attributes
    if file.present? && file_changed?
      self.original_filename = file.file.filename if file.file.respond_to?(:filename)
      self.file_size = file.file.size if file.file.respond_to?(:size)
      self.file_type = file.file.content_type if file.file.respond_to?(:content_type)
    end
  end
end

# == Schema Information
#
# Table name: attachments
#
#  id                :bigint           not null, primary key
#  attachable_type   :string           indexed => [attachable_id]
#  file              :string
#  file_description  :string
#  file_size         :integer
#  file_type         :string
#  original_filename :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  attachable_id     :integer          indexed => [attachable_type]
#
# Indexes
#
#  index_attachments_on_attachable_type_and_attachable_id  (attachable_type,attachable_id)
#
