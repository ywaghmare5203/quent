class CreateWebservices < ActiveRecord::Migration[5.1]
  def change
    create_table :webservices do |t|
      t.string :name
      t.text :url
      t.string :req_type
      t.boolean :status

      t.timestamps
    end
  end
end
