class GeneratedImage < ApplicationRecord
  has_attached_file :image, styles: { medium: '975x975>', thumb: '150x150>' }
  belongs_to :content_image, class_name: 'SourceImage'
  belongs_to :style_image, class_name: 'SourceImage'

  validates_presence_of :content_image, :style_image
end
