class AddIndexOnUpdatedAtAndRemoveExpiredate < ActiveRecord::Migration
	def change
		remove_column :locations, :expiredate
		add_index :locations, :updated_at
	end
end
