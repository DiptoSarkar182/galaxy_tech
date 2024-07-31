class AddUpdatedAtToSolidCacheEntries < ActiveRecord::Migration[7.1]
  def change
    add_column :solid_cache_entries, :updated_at, :datetime, null: false
  end
end
