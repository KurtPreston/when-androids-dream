class SourceImage < ApplicationRecord
  has_attached_file :image, styles: { medium: '975x975>', thumb: '150x150>' }
  validates_attachment :image,
    presence: true,
    size: { in: 0..10.megabytes },
    content_type: {content_type: /\Aimage\/.*\z/}
end
