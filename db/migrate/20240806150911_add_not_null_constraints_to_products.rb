class AddNotNullConstraintsToProducts < ActiveRecord::Migration[7.1]
  def change
    change_column_null :products, :name, false
    change_column_null :products, :price, false
    change_column_null :products, :quantity, false
    change_column_null :products, :brand, false
    change_column_null :products, :component, false
  end
end
