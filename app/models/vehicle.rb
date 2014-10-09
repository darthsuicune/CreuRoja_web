class Vehicle < ActiveRecord::Base
	default_scope { order(indicative: :asc) }
	
	has_many :vehicle_services, dependent: :destroy
	has_many :services, through: :vehicle_services
	has_many :vehicle_assemblies, dependent: :destroy
	has_many :assemblies, through: :vehicle_assemblies
	has_many :service_users, dependent: :destroy
	has_many :vehicle_positions, dependent: :destroy

	validates :indicative, presence: true
	validates :brand, presence: true
	validates :model, presence: true
	validates :license, presence: true
	validates :vehicle_type, presence: true
	validates :places, presence: true
	
	after_initialize :validate_licenses
	
	def to_s
		"#{indicative}"
	end
	
	def add_to_service(service)
		vehicle_services.create(service_id: service.id)
	end
	
	def add_to_assembly(assembly)
		vehicle_assemblies.create(assembly_id: assembly.id)
	end
	
	def add_to_service_user(user, service, user_position)
		service_users.create(user_id: user.id, service_id: service.id, user_position: user_position)
	end
	
	def translated_vehicle_type
		case vehicle_type
		when "alfa bravo"
			I18n.t(:vehicle_type_alfa_bravo)
		when "alfa mike"
			I18n.t(:vehicle_type_alfa_mike)
		when "mike"
			I18n.t(:vehicle_type_mike)
		when "romeo"
			I18n.t(:vehicle_type_romeo)
		when "tango"
			I18n.t(:vehicle_type_tango)
		else
			"dafuq"
		end
	end
	
	def driver(service)
		self.service_users.where(user_position: ["b1","btp","per"], service_id: service.id).first
	end
	
	def available?
		validate_licenses
	end

	protected
		def defaults
		end
		
		def validate_licenses
			self.operative = false if self.itv && self.itv < Date.today
			self.operative = false if self.sanitary_cert && self.sanitary_cert < Date.today
			self.save if self.operative == false
			self.operative
		end
end
