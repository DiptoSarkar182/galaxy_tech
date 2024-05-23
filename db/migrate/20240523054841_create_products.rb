class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price, precision: 9, scale: 2
      t.integer :quantity
      t.string :brand
      t.text :key_features
      t.text :specification

      t.timestamps
    end
  end
end
