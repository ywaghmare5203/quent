class AddAttachmentOptionCataloguesMediaToOptionCatalogues < ActiveRecord::Migration[5.1]
  def self.up
    change_table :option_catalogues do |t|
      t.attachment :option_catalogues_media
    end
  end

  def self.down
    remove_attachment :option_catalogues, :option_catalogues_media
  end
end
