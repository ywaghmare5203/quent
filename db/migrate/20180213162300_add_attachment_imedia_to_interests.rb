class AddAttachmentImediaToInterests < ActiveRecord::Migration[5.1]
  def self.up
    change_table :interests do |t|
      t.attachment :imedia
    end
  end

  def self.down
    remove_attachment :interests, :imedia
  end
end
