class CreateAssemblies < ActiveRecord::Migration
	def change
		create_table :assemblies do |t|
			t.string :name
			t.string :description
			t.string :level
			t.integer :depends_on

			t.timestamps
		end
		
		add_index :assemblies, [:name], unique: true
		add_index :assemblies, [:description], unique: false
		add_index :assemblies, [:level], unique: false
	end
end
