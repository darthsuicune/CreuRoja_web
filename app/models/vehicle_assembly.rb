class VehicleAssembly < ActiveRecord::Base
	belongs_to :vehicle
	belongs_to :assembly
	
	validates :vehicle_id, presence: true
	validates :assembly_id, presence: true
end
