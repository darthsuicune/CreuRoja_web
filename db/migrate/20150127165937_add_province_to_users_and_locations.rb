class AddProvinceToUsersAndLocations < ActiveRecord::Migration
	def change
		add_column :users, :province_id, :integer
		add_column :locations, :province_id, :integer
	end
end
