class AddOfficeToAssemblies < ActiveRecord::Migration
	def change
		add_column :assemblies, :location_id, :integer
	end
end
