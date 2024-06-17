class CreateAddToWishLists < ActiveRecord::Migration[7.1]
  def change
    create_table :add_to_wish_lists do |t|
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.timestamps
    end
  end
end
