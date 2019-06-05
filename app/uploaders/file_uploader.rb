# frozen_string_literal: true

class FileUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    [
      'private',
      Current.account.tenant_name,
      model.class.to_s.underscore,
      mounted_as,
      model.id
    ].join '/'
  end
end
