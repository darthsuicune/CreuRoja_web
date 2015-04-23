class Location < ActiveRecord::Base
	default_scope { order(location_type: :desc) }
	scope :active_locations, -> { where(active: true) }
	scope :offices, -> { where(active: true, location_type: "asamblea") }
	scope :updated_after, -> (time) { where("updated_at > ?", time) }
	
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
	
	def active_services
		services.unfinished_before(Time.now).not_archived.public_data
	end
	
	def self.from_assemblies(assembly_list)
		Location.where(id: AssemblyLocation.joins(:location).where(assembly_id: assembly_list.ids))
	end
	
	def self.general
		["asamblea", "hospital", "cuap", "nostrum"]
	end
	
	def self.location_types
		Location.active_locations.select(:location_type).distinct
	end
	
	def general?
		location_type != "terrestre" && location_type != "maritimo" && location_type != "adaptadas" && location_type != "bravo"
	end
	
	def self.serviced(user, level, updated_at = nil)
		if updated_at
			apply_filters(user, level).updated_after(updated_at)
		else
			apply_filters(user, level).active_locations
		end
	end

=begin
 Applies the following filters for general locations:
 - The general locations are added to at least one assembly from all assemblies in the user's 
       autonomic community. This inludes several autonomic communities in case a user is in 
       assemblies from different communities.
 - The locations that requiere a service to be shown are obtained from the list of services
       that are available to the user through their assemblies and not yet finished
=end
	def self.apply_filters(user, level)
		conditions = "(id IN (?) AND location_type IN (?)) OR (id IN (?) AND location_type IN (?))"
		where(conditions, 
		      Location.location_ids_with_pending_services(user), allowed_types(user.user_types), 
		      Location.general_location_ids_for_user(user, level), allowed_general_types(user.user_types))
	end
	
	def self.location_ids_with_pending_services(user)
		Location.joins(:location_services).where("service_id IN (?)", Service.pending_services(user).ids).ids
	end
	
	def self.general_location_ids_for_user(user, level)
		Location.joins(:assembly_locations).where("assembly_id IN (?)", user.accessable_assemblies_until_level(level)).ids
	end
	
	def self.allowed_general_types(user_types)
		types = general
		unless user_types.nil?
			user_types.each do |user_type|
				case user_type.user_type
				when "acu"
					types << "salvamento"
				when "b1"
					types << "gasolinera"
				when "btp"
					types << "gasolinera"
				when "d1"
					types << "gasolinera"
				when "per"
					types << "salvamento"
				end
			end
		end
		types.uniq
	end
	
	def self.allowed_types(user_types)
		types = []
		unless user_types.nil?
			user_types.each do |user_type|
				case user_type.user_type
				when "acu"
					types << "maritimo"
				when "asi"
					types << "terrestre"
					types << "bravo"
				when "per"
					types << "maritimo"
				when "soc"
					types << "adaptadas"
				end
			end
		end
		types.uniq
	end
	
	private
	def defaults
	end
end
