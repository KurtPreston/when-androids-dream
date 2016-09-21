class CreateGeneratedImages < ActiveRecord::Migration[5.0]
  def change
    create_table :generated_images do |t|
      t.attachment :image
      t.references :content_image, references: :source_images, foreign_key: true
      t.references :style_image, references: :source_images, foreign_key: true

      t.timestamps
    end
  end
end
