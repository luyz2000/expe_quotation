class AttachmentUploader < CarrierWave::Uploader::Base
  # Choose what kind of storage to use for this uploader:
  storage :file

  # Override the directory where uploaded files will be stored.
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Add a whitelist of extensions which are allowed to be uploaded.
  def extension_allowlist
    %w(jpg jpeg gif png pdf doc docx xls xlsx txt)
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url(*args)
    # For Rails 3.1+ asset pipeline compatibility:
    ActionController::Base.helpers.asset_path('fallback/' + [version_name, 'default.png'].compact.join('_'))
  end
end