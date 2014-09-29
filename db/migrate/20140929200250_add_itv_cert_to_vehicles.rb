class AddItvCertToVehicles < ActiveRecord::Migration
	def change
		add_column :vehicles, :itv, :date
		add_column :vehicles, :sanitary_cert, :date
	end
end
