class CreateSourceImages < ActiveRecord::Migration[5.0]
  def change
    create_table :source_images do |t|

      t.timestamps
    end
  end
end
