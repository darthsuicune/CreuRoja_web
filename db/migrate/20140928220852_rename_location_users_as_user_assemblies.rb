class RenameLocationUsersAsUserAssemblies < ActiveRecord::Migration
	def change
		rename_table :location_users, :user_assemblies
	end
end
