class CreateVitaminPacks < ActiveRecord::Migration[5.1]
  def change
    create_table :vitamin_packs do |t|
      t.string :name
      t.integer :user_id
    end
  end
end
