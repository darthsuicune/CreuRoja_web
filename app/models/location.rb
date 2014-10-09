class Location < ActiveRecord::Base
	default_scope { order(location_type: :desc) }
	scope :updated_after, ->(time) { where("updated_at > ?", time) }
	
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
	
	def add_to_assembly(assembly)
		assembly_locations.create(assembly_id: assembly.id)
	end
	
	def add_to_service(service)
		location_services.create(service_id: service.id)
	end
	
	def add_user_to_service(user, user_position, service)
		service_users.create(user_id: user.id, service_id: service.id, user_position: user_position)
	end
	
	def general?
		location_type != "terrestre" && location_type != "maritimo" && location_type != "salvamento"
	end
	
	def self.serviced
		where(location_type: Location.general)
	end
	
	def self.general
		["asamblea", "hospital", "cuap", "nostrum", "gasolinera", "salvamento"]
	end
	
	def self.offices
		active_locations.where(location_type: "asamblea")
	end
	
	def self.active_locations
		where(active: true)
	end
	
	def self.location_types
		Location.active_locations.select(:location_type).distinct
	end
	
	private
	def defaults
	end
end
