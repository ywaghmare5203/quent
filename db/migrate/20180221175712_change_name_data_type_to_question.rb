class ChangeNameDataTypeToQuestion < ActiveRecord::Migration[5.1]
  def change
  	change_column :questions, :name, :string
  end
end
