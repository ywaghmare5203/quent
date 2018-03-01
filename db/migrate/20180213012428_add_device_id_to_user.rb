class AddDeviceIdToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :device_id, :string
  end
end
