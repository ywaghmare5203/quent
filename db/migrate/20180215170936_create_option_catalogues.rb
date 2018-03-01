class CreateOptionCatalogues < ActiveRecord::Migration[5.1]
  def change
    create_table :option_catalogues do |t|
      t.string :option_text
      t.references :question, foreign_key: true

      t.timestamps
    end
  end
end
