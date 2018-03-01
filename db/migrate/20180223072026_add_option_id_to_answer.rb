class AddOptionIdToAnswer < ActiveRecord::Migration[5.1]
  def change
  	add_column :answers, :option_catalogue_id, :integer
  end
end
