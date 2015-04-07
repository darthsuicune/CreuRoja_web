class RemoveIndicativeFromVehiclePositions < ActiveRecord::Migration
	def change
		remove_column :vehicle_positions, :indicative
	end
end
