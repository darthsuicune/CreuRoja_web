class RenameLocationUsersAsUserAssemblies < ActiveRecord::Migration
	def change
		rename_table :location_users, :user_assemblies
		change_table :user_assemblies do |t|
			t.rename :location_id, :assembly_id
		end
	end
end
