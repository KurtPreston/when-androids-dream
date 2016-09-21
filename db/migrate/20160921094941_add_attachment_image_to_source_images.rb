class AddAttachmentImageToSourceImages < ActiveRecord::Migration
  def self.up
    change_table :source_images do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :source_images, :image
  end
end
