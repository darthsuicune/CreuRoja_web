class RenameVehicleAssembliesField < ActiveRecord::Migration
	def change
		change_table :vehicle_assemblies do |t|
			t.rename :location_id, :assembly_id
		end
	end
end
