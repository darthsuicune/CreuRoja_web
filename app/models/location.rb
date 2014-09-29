class Location < ActiveRecord::Base
	default_scope { order(location_type: :desc) }
	has_many :assembly_locations, dependent: :destroy
	has_many :assemblies, through: :assembly_locations
	has_many :location_services, dependent: :destroy
	has_many :services, through: :location_services
	has_many :service_users, dependent: :destroy
	
	before_validation :defaults
	
	validates :name, presence: true
	validates :address, presence: true
	validates :latitude, presence: true
	validates :longitude, presence: true
	validates :location_type, presence: true
	
	def self.offices
		Location.active_locations.where(location_type: "asamblea")
	end
	
	def self.active_locations
		Location.where(active: true)
	end
	
	def self.location_types
		types = []
		Location.active_locations.select(:location_type).distinct.each do |location|
			types << location.location_type
		end
		types
	end
	
	private
	def defaults
	end
end
