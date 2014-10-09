class User < ActiveRecord::Base
	default_scope { order(name: :asc, surname: :asc) }
	has_secure_password

	has_many :user_assemblies, dependent: :destroy
	has_many :assemblies, through: :user_assemblies
	has_many :sessions, dependent: :destroy
	has_many :user_types, dependent: :destroy
	has_many :service_users
	has_many :services, through: :service_users
	
	accepts_nested_attributes_for :user_types, allow_destroy: true
	
	before_save { email.downcase!
	              role.downcase unless role.nil? }
	
	before_create :defaults
	before_validation :set_initial_password

	VALID_EMAIL_FORMAT = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_FORMAT }, 
			uniqueness: { case_sensitive: false }
	validates :name, presence: true, length: { maximum: 60 }
	validates :surname, presence: true, length: { maximum: 60 }
	validates :password, length: { minimum: 6 }, on: :create
	validates :password, length: { minimum: 6 }, on: :update, allow_blank: true
	validates :password_confirmation, length: { minimum: 6 }, on: :create
	validates :password_confirmation, length: { minimum: 6 }, on: :update, allow_blank: true
  
	after_validation { self.errors.messages.delete(:password_digest) }
	
	def add_to_assembly(assembly)
		user_assemblies.create(assembly_id: assembly.id)
	end
	
	def add_to_service(service, user_position, location = nil, vehicle = nil)
		service_users.create(service_id: service.id, vehicle_id: vehicle.id, user_position: user_position) if location.nil?
		service_users.create(service_id: service.id, location_id: location.id, user_position: user_position) if vehicle.nil?
	end
	
	def get_visible_locations
		Location.active_locations
	end

	def allowed_to?(action)
		return false if active == false
		return true if role == "admin"
		case action
		when :see_map
			role == "volunteer" || role == "technician"
		when :see_own_profile
			role == "volunteer" || role == "technician"
		when :see_user_list
			role == "technician"
		when :see_location_list
			role == "technician"
		when :see_vehicle_list
			role == "technician"
		when :see_all_vehicles
			false
		when :see_service_list
			role == "technician"
		when :add_to_own_assembly
			role == "technician"
		when :add_to_any_assembly
			false
		when :manage_users
			role == "technician"
		when :destroy_users
			role == "technician"
		when :manage_admin_users
			false
		when :manage_assemblies
			role == "assemblies"
		when :manage_issues
			role == "technician"
		when :manage_locations
			role == "technician"
		when :manage_services
			role == "technician"
		when :manage_vehicles
			role == "technician"
		when :assign_service_to_location
			role == "technician"
		when :assign_vehicle_to_service
			role == "technician"
		when :assign_user_to_service
			role == "technician"
		else
			false
		end
	end
	
	def create_reset_password_token(time = Time.now)
		self.resettoken = SecureRandom.urlsafe_base64
		self.resettime = time
		if self.save!
			UserMailer.password_reset(self).deliver
		end
	end
	
	def reset_password(password)
		self.password = password
		self.password_confirmation = password
		self.resettoken = nil
		self.save
	end

	def create_session_token
		self.sessions.create(token: SecureRandom.urlsafe_base64)
	end
	
	def translated_role
		case role
		when "admin"
			I18n.t(:role_admin)
		when "technician"
			I18n.t(:role_technician)
		else #when "volunteer"
			I18n.t(:role_volunteer)
		end
	end
	
	def self.positions
		#TODO: Add more possible positions, or take it from a different place
		[[I18n.t(:position_b1), "b1"], [I18n.t(:position_per), "per"]]
	end
	
	def vehicles
		if self.allowed_to?(:see_all_vehicles)
			Vehicle.all
		else
			ids = UserAssembly.select(:assembly_id).joins(:user).where(user_id: self.id)
			Vehicle.distinct.joins(:vehicle_assemblies).where(vehicle_assemblies: { assembly_id: ids })
		end
	end
	
	def types
		combined = ""
		self.user_types.each do |type|
			"#{combined}#{type.to_s};"
		end
		combined[0, combined.length - 1]
	end
	
	def for_session
		{ id: self.id, name: self.name, surname: self.surname, email: self.email, phone: self.phone, accessToken: self.sessions.last.token, role: self.role, active: self.active, types: self.types }
	end
	
	private
		def defaults
			self.language ||= "ca"
			self.role ||= "volunteer"
			self.phone ||= 0
		end
		
		def set_initial_password
			if self.password_digest.nil?
				temp = SecureRandom.urlsafe_base64
				self.password = temp 
				self.password_confirmation = temp
			end
		end
end
