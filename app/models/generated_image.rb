class GeneratedImage < ApplicationRecord
  has_attached_file :image, styles: { medium: '875x875>', thumb: '150x150>' }
  belongs_to :content_image, class_name: 'SourceImage'
  belongs_to :style_image, class_name: 'SourceImage'

  validates_presence_of :content_image, :style_image, :iterations
  validates :iterations,
    presence: true,
    numericality: {
      only_integer: true,
      greated_than_or_equal_to: 1,
      less_than_or_equal_to: 1000
    }
  validates_attachment :image,
    size: { in: 0..20.megabytes },
    content_type: {content_type: /\Aimage\/.*\z/}

  after_commit :generate_image, on: :create

  def generate_image
    GenerateNeuralStyleTransferImageJob.perform_later(self)
  end
end
