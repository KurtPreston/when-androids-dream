class AddIterationsToGeneratedImage < ActiveRecord::Migration[5.0]
  def change
    add_column :generated_images, :iterations, :integer
  end
end
