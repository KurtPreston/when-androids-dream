require 'open-uri'

class SourceImage < ApplicationRecord
  has_attached_file :image, styles: { medium: '875x875>', thumb: '150x150>' }
  validates_attachment :image,
    presence: true,
    size: { in: 0..20.megabytes },
    content_type: {content_type: /\Aimage\/.*\z/}

  before_validation :get_file_from_upload_url
  attr_accessor :upload_url

  private

  def get_file_from_upload_url
    if new_record? && upload_url.present?
      self.image = open(upload_url)
    end
  end
end
