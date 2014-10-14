class Location < ActiveRecord::Base
	default_scope { order(location_type: :desc) }
	scope :updated_after, ->(time) { where("updated_at > ?", time) }
	scope :active_locations, -> { where(active: true) }
	scope :offices, -> { where(active: true, location_type: "asamblea") }
	
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
		location_type != "terrestre" && location_type != "maritimo"
	end
	
	def self.serviced(user)
		pending_services = LocationService.joins(:service).where("(end_time) > ? AND (assembly_id IN (?))", Time.now.to_s, user.assemblies.ids).distinct.ids
		where("(id IN (?)) OR (location_type IN (?))", pending_services, Location.general)
	end
	
	def self.filter_by_user_types(user_types, updated_at = nil)
		if updated_at
			updated_after updated_at 
		else
			active_locations
		end
	end
	
	def self.general
		["asamblea", "hospital", "cuap", "nostrum", "gasolinera", "salvamento"]
	end
	
	def self.location_types
		Location.active_locations.select(:location_type).distinct
	end
	
	private
	def defaults
	end
end
