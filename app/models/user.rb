class User < ActiveRecord::Base
	# This class contains two references to services, "services" which replies with the
	# services the user has signed up for, and available_services, that returns the services 
	# the user can see.
	
	# It also contains two ways of getting its types. user_types (relation) returns a relation 
	# with the user types, while "types" returns a comma-separated string with all together.
	
	# Other convenience methods include:
	# assembly_users: Retrieves the users from the same and dependant assemblies
	# assembly_ids: Retrieves the ids of the assemblies the user has access to
	# types: Returns a string with a comma separated list of the user types
	
	default_scope { order(name: :asc, surname: :asc) }
	has_secure_password

	has_many :user_assemblies, dependent: :destroy
	has_many :assemblies, through: :user_assemblies
	has_many :sessions, dependent: :destroy
	has_many :user_types, dependent: :destroy
	has_many :service_users
	has_many :services, through: :service_users
	
	accepts_nested_attributes_for :user_types, allow_destroy: true
	
	before_save do
		email.downcase!
		role.downcase! unless role.nil?
	end
	
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
	
	def full_name
		"#{name} #{surname}"
	end
	
	def full_name_with_email
		"#{name} #{surname} (#{email})"
	end
	
	def in_assembly_of?(user)
		(assemblies & user.assemblies).count > 0
	end
	
	def can_see_logs_of? (log_user)
		self.role == "admin" || (!log_user.nil? && self.in_assembly_of?(log_user))
	end
	
	def managed_assemblies
		result = []
		user_assemblies.each do |ua|
			result << ua.assembly.managed_ids
		end
		Assembly.where(id: result)
	end
	
	def available_locations
		if self.allowed_to?(:see_all_locations)
			Location.all 
		else
			Location.from_assemblies(self.managed_assemblies)
		end
	end
	
	def map_elements(level, updated_at = nil)
		if self.allowed_to?(:see_all_locations)
			Location.all 
		else
			Location.serviced(self, level, updated_at)
		end
	end
	
	def add_to_assembly(assembly)
		user_assemblies.create(assembly_id: assembly.id) unless self.assemblies.include? assembly
	end

	def add_to_service_at_location(service, user_position, location)
		service_users.create(service_id: service.id, location_id: location.id, user_position: user_position)
	end
	
	def add_to_service_in_vehicle(service, user_position, vehicle)
		service_users.create(service_id: service.id, vehicle_id: vehicle.id, user_position: user_position)
	end
	
	#A user can sign up for a service without specifying location nor vehicle
	def sign_up_for_service(service, user_position)
		service_users.create(service_id: service.id, user_position: user_position)
	end
	
	#The type should be passed as a string
	def add_type(type)
		user_types.create(user_type: type)
	end

	def allowed_to?(action)
		return false if active == false
		return true if role == "admin"
		case action
		when :see_map
			true
		when :see_own_profile
			true
		when :see_user_list
			role == "technician"
		when :see_location_list
			role == "technician"
		when :see_vehicle_list
			role == "technician"
		when :see_service_list
			role == "technician"
		when :add_to_own_assembly
			role == "technician"
		when :manage_users
			role == "technician"
		when :destroy_users
			role == "technician"
		when :manage_assemblies
			role == "technician"
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
		when :assign_users_to_assemblies
			role == "technician"
		when :assign_location_to_assembly
			role == "technician"
		when :add_to_any_assembly #For admins or future use
			false
		when :see_all_vehicles
			false
		when :see_all_services
			false
		when :see_all_locations
			false
		when :see_all_users
			false
		when :manage_admin_users
			false
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
		self.resettime = 20.years.ago
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
	
	def vehicles
		if self.allowed_to?(:see_all_vehicles)
			Vehicle.all
		else
			Vehicle.distinct.joins(:vehicle_assemblies).where(vehicle_assemblies: { assembly_id: assembly_ids })
		end
	end
	
	def available_services
		if self.allowed_to?(:see_all_services)
			Service.all
		else
			Service.where(assembly_id: assembly_ids)
		end
	end
	
	def in_service?(service)
		services.include? service
	end
	
	def assembly_users
		if self.allowed_to?(:see_all_users)
			User.all
		else
			User.distinct.joins(:user_assemblies).where(user_assemblies: { assembly_id: assembly_ids })
		end
	end
	
	def assembly_ids
		ids = []
		assemblies.each do |assembly|
			ids += assembly.managed_ids
			ids << assembly.id
		end
		ids.uniq
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
	
	def goes_to?(service)
		service.users.include? self
	end
	
	def accessable_assemblies_until_level(level)
		level_assemblies = []
		self.assemblies.each do |assembly|
			parent = assembly.find_parent_with_level(level)
			level_assemblies << parent unless level_assemblies.include? parent
		end
		all_assemblies_in_level = []
		level_assemblies.each do |assembly|
			assembly.managed_assemblies.each do |managed|
				all_assemblies_in_level << managed unless all_assemblies_in_level.include? managed
			end
		end
		all_assemblies_in_level.sort
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
