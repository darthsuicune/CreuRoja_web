class Assembly < ActiveRecord::Base
	default_scope { order(name: :asc) }
	
	has_many :user_assemblies, dependent: :destroy
	has_many :users, through: :user_assemblies
	has_many :assembly_locations, dependent: :destroy
	has_many :locations, through: :assembly_locations
	has_many :vehicle_assemblies, dependent: :destroy
	has_many :vehicles, through: :vehicle_assemblies
	has_many :services
	
	validates :name, presence: true
	validates :level, presence: true
	validates :location_id, presence: true
	
	def office
		Location.where(id: location_id).first
	end
	
	def address
		office.address
	end
	
	def phone
		office.phone
	end
	
	def parent
		Assembly.where(id: self.depends_on).first if self.depends_on
	end
	
	def add_vehicle(vehicle)
		VehicleAssembly.create(vehicle_id: vehicle.id, assembly_id: self.id)
	end
	
	def add_user(user)
		UserAssembly.create(user_id: user.id, assembly_id: self.id)
	end
	
	def add_location(location)
		AssemblyLocation.create(location_id: location.id, assembly_id: self.id)
	end
	
	def dependant_assemblies
		assemblies = []
		child_assemblies(assemblies)
		assemblies
	end
	
	def self.levels
		[[I18n.t(:assembly_level_local), "local"], [I18n.t(:assembly_level_province), "provincial"], [I18n.t(:assembly_level_region), "autonomica"]]
	end
	
	def self.not_locals
		Assembly.where.not(level: "local")
	end
	
	def to_s
		self.name
	end
	
	private
		def child_assemblies(assemblies, assembly = self)
			dependants = Assembly.where(depends_on: assembly.id)
			assemblies << assembly
			dependants.each { |child| child_assemblies(assemblies, child) } if dependants.count != 0
		end
end
