class RemoveProvinceReferences < ActiveRecord::Migration
	def change
		remove_column :users, :province_id, :integer
		remove_column :locations, :province_id, :integer
		drop_table :provinces
	end
end
