module ServicesHelper
	#NOTE:
	#This methods are extracted from the VIEWS to increase readability. 
	#They are thought for creating an array of values usable in select forms.
	
	#Service: Service for which the vehicles are requested
	def get_available_vehicles(service)
		availables = []
		Vehicle.where(operative: true).each do |vehicle|
			#If the service already has the vehicle, ignore
			unless service.vehicles.include?(vehicle)
				is_available = true
				#Assignment: Services for which the vehicle is already assigned
				vehicle.services.each do |assignment|
					#If the assigned services match in time with the service wanted, mark it as not available
					is_available = false if (service.base_time < assignment.end_time && service.end_time > assignment.base_time)
				end
				availables << [vehicle.tag, vehicle.id] if is_available
			end
		end
		availables
	end
	
	def get_available_locations(service)
		locations = []
		Location.active_locations.each do |location|
			locations << [location.name, location.id] unless service.locations.include?(location)
		end
		locations
	end
	
	def get_available_users(service)
		availables = []
		User.where(active: true).each do |user|
			unless service.users.include?(user)
				is_available = true
				user.services.each do |assignment|
					is_available = false if (service.base_time < assignment.end_time && service.end_time > assignment.base_time)
				end
			end
			availables << [user.full_name, user.id] if is_available
		end
		availables
	end
	
	def locations_for_user_service(locations)
		available_locations = []
		available_locations << [I18n.t(:user_goes_in_vehicle), -1]
		locations.each do |location|
			available_locations << [location.name, location.id]
		end
		available_locations
	end
	
	def vehicles_for_user_service(vehicles)
		available_vehicles = []
		available_vehicles << [I18n.t(:user_goes_to_location), -1]
		vehicles.each do |vehicle|
			available_vehicles << [vehicle.indicative, vehicle.id]
		end
		available_vehicles
	end
end
