class VehicleService < ActiveRecord::Base
	belongs_to :service
	belongs_to :vehicle
	
	before_validation :defaults
	
	validates :vehicle_id, presence: true
	validates :service_id, presence: true
	
	private
		def defaults
		end
end
