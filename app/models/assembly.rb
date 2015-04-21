class Assembly < ActiveRecord::Base
	default_scope { order(name: :asc, level: :asc) }
	default_scope { order(name: :asc) }
	scope :estate, -> { where(level: "estatal") }
	scope :autonomicas, -> { where(level: "autonomica") }
	scope :provincials, -> { where(level: "provincial") }
	scope :locals, -> { where(level: ["local","comarcal","delegation"]) }
	scope :independent_provincials, -> { provincials.where(depends_on: nil) }
	scope :independent_locals, -> { locals.where(depends_on: nil) }
	
	has_many :user_assemblies, dependent: :destroy
	has_many :users, through: :user_assemblies
	has_many :assembly_locations, dependent: :destroy
	has_many :locations, through: :assembly_locations
	has_many :vehicle_assemblies, dependent: :destroy
	has_many :vehicles, through: :vehicle_assemblies
	has_many :services
	has_many :children, class_name: "Assembly", foreign_key: "depends_on"
	
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
		Assembly.find(self.depends_on) if self.depends_on
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
	
	def self.not_locals
		Assembly.where.not(level: ["local","comarcal","delegation"])
	end
	
	def translated_level
		case level
		when "estatal"
			I18n.t(:level_state)
		when "autonomica"
			I18n.t(:level_region)
		when "provincial"
			I18n.t(:level_province)
		when "comarcal"
			I18n.t(:level_comarcal)
		when "local"
			I18n.t(:level_local)
		when "delegation"
			I18n.t(:level_delegation)
		else
			"dafuq"
		end
	end
	
	def to_s
		self.name
	end
	
	def find_parent_with_level(level, assembly = self)
		(assembly.level == level) ? assembly : find_parent_with_level(level, assembly.parent)
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
