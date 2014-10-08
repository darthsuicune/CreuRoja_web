class Assembly < ActiveRecord::Base
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
		Location.find(location_id)
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
		vehicle_assemblies.create(vehicle_id: vehicle.id)
	end
	
	def add_user(user)
		user_assemblies.create(user_id: user.id)
	end
	
	def add_location(location)
		assembly_locations.create(location_id: location.id)
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
