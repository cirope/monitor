class FileUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "private/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
