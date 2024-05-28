class RemoveSlugFromProducts < ActiveRecord::Migration[7.1]
  def change
    remove_column :products, :slug, :string
  end
end
