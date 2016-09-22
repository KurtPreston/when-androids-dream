class CreateGeneratedImages < ActiveRecord::Migration[5.0]
  def change
    create_table :generated_images do |t|
      t.attachment :image
      t.references :content_image, references: :source_images
      t.references :style_image, references: :source_images

      t.timestamps
    end

    add_foreign_key :generated_images, :source_images, column: :content_image_id
    add_foreign_key :generated_images, :source_images, column: :style_image_id
  end
end
