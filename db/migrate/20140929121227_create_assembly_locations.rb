class CreateAssemblyLocations < ActiveRecord::Migration
	def change
		create_table :assembly_locations do |t|
			t.integer :location_id
			t.integer :assembly_id

			t.timestamps
		end
		
		add_index :assembly_locations, [:location_id, :assembly_id], unique: true
	end
end
