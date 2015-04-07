class VehiclePosition < ActiveRecord::Base
	belongs_to :vehicle

	validates :vehicle_id, presence: true
	validates :vehicle, presence: true
	validates :latitude, presence: true
	validates :longitude, presence: true
	validate :location_is_valid
	
	def indicative
		self.vehicle.indicative
	end
	
	def last_position
		self.vehicle.last_position
	end
	
	private
	def location_is_valid
		latitude && latitude < 180 && latitude > -180 && 
				longitude && longitude < 180 && longitude > -180 
	end
end
