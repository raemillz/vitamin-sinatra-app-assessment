class CreateVitamins < ActiveRecord::Migration[5.1]
  def change
    create_table :vitamins do |t|
      t.string :name
      t.string :benefits
      t.integer :vitamin_pack_id
    end
  end
end
