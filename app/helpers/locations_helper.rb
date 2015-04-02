module LocationsHelper
	def available_services(user_assemblies, location_assemblies)
		result = []
		available(user_assemblies, location_assemblies).each do |assembly|
			result << [assembly.name, assembly.id]
		end
		result
	end
	
	def can_add_assemblies?(user, location)
		user.allowed_to?(:assign_location_to_assembly) && available(user.managed_assemblies, location.assemblies).count > 0
	end
	
	def available(user_assemblies, location_assemblies)
		intersection = user_assemblies & location_assemblies
		user_assemblies - intersection
	end
end
