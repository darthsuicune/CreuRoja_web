class ModifyIndexInAssemblies < ActiveRecord::Migration
	def change
		remove_index :assemblies, [:name]
		add_index :assemblies, [:name, :level], unique: true
	end
end
