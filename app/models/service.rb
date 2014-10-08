class Service < ActiveRecord::Base
	default_scope { order(base_time: :desc) }
	
	belongs_to :assembly
	has_many :vehicle_services, dependent: :destroy
	has_many :vehicles, through: :vehicle_services
	has_many :service_users, dependent: :destroy
	has_many :users, through: :service_users
	has_many :location_services, dependent: :destroy
	has_many :locations, through: :location_services
	
	validates :name, presence: true
	validates :assembly_id, presence: true
	validates :base_time, presence: true
	validates :start_time, presence: true
	validates :end_time, presence: true
	
	def add_location(location)
		location_services.create(location_id: location.id)
	end
	
	def add_user(user, user_position, location = nil, vehicle = nil)
		service_users.create(user_id: user.id, vehicle_id: vehicle.id, user_position: user_position) if location.nil?
		service_users.create(user_id: user.id, location_id: location.id, user_position: user_position) if vehicle.nil?
	end
	
	def add_vehicle(vehicle)
		vehicle_services.create(vehicle_id: vehicle.id)
	end
	
	def first_location_id
		locations.first.id
	end
	
	def expired?
		Time.now > end_time 
	end
	
	def in_base_time?(time)
		base_time <= time && time < start_time
	end
	
	def started?(time)
		start_time <= time && time < end_time
	end
	
	def finished?(time)
		time >= end_time
	end
	
	def self.last_date
		Service.order("end_time DESC").first.end_time
	end
end
