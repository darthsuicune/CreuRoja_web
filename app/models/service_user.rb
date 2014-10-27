class ServiceUser < ActiveRecord::Base
	belongs_to :user
	belongs_to :service
	belongs_to :location
	belongs_to :vehicle
	
	before_validation :defaults
	
	validates :service_id, presence: true
	validates :user_id, presence: true
	validates :user_position, presence: true
	validate :can_have_only_vehicle_or_location
	
	def name
		self.user.name
	end
	
	def surname
		self.user.surname
	end
	
	def add_to_location(location, position = nil)
		self.location_id = location.id
		self.user_position = position if position
		self.vehicle_id = nil
		self.save!
	end
	
	def add_to_vehicle(vehicle, position = nil)
		self.vehicle_id = vehicle.id
		self.user_position = position if position
		self.location_id = nil
		self.save!
	end
	
	private
	def defaults
	end
	
	def can_have_only_vehicle_or_location
		if self.vehicle && self.location
			errors.add(:vehicle, I18n.t(:error_cannot_have_vehicle_and_location))
			errors.add(:location, I18n.t(:error_cannot_have_vehicle_and_location))
		end
	end
end
