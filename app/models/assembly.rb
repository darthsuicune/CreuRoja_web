class Assembly < ActiveRecord::Base
	default_scope { order(name: :asc, level: :asc) }
	default_scope { order(name: :asc) }
	
	has_many :user_assemblies, dependent: :destroy
	has_many :users, through: :user_assemblies
	has_many :assembly_locations, dependent: :destroy
	has_many :locations, through: :assembly_locations
	has_many :vehicle_assemblies, dependent: :destroy
	has_many :vehicles, through: :vehicle_assemblies
	has_many :services
	
	before_validation :defaults
	
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
	
	def managed_assemblies
		assemblies = []
		child_assemblies(assemblies)
		assemblies
	end
	
	def managed_ids
		ids = []
		child_ids(ids)
		ids
	end
	
	def self.levels
		[[I18n.t(:assembly_level_local), "local"], [I18n.t(:assembly_level_delegation), "delegation"], [I18n.t(:assembly_level_comarcal), "comarcal"], [I18n.t(:assembly_level_province), "provincial"], [I18n.t(:assembly_level_region), "autonomica"]]
	end
	
	def self.not_locals
		Assembly.where.not(level: ["local","comarcal","delegation")
	end
	
	def translated_level
		case level
		when "autonomica"
			I18n.t(:level_region)
		when "provincial"
			I18n.t(:level_province)
		when "comarcal"
			I18n.t(:level_comarcal)
		when "delegation"
			I18n.t(:level_delegation)
		when "local"
			I18n.t(:level_local)
		else
			"dafuq"
		end
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
		
		def child_ids(ids, assembly = self)
			dependants = Assembly.where(depends_on: assembly.id)
			ids << assembly.id
			dependants.each { |child| child_ids(ids, child) } if dependants.count != 0
		end
		
		def defaults
			self.depends_on = nil if self.depends_on == "-"
		end
end
