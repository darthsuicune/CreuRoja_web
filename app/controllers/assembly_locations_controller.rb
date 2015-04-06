class AssemblyLocationsController < ApplicationController
	before_filter :signed_in_user
	before_filter :is_valid_user
	
	def create
		assembly_location = AssemblyLocation.new(assembly_location_params)
		if log_action_result(assembly_location, validate_relation(assembly_location))
			redirect_to assembly_location.location, notice: I18n.t(:location_assigned_to_assembly)
		else
			if Assembly.exists?(params[:assembly_location][:assembly_id])
				redirect_to assembly_location.assembly
			elsif Location.exists?(params[:assembly_location][:location_id])
				redirect_to assembly_location.location
			else
				redirect_to assemblies_path
			end
		end
	end

	def update
		assembly_location = AssemblyLocation.find(params[:id])
		log_action_result assembly_location, assembly_location.update(assembly_location_params)
		redirect_to(assembly_location.location)
	end

	def destroy
		assembly_location = AssemblyLocation.find(params[:id])
		log_action_result assembly_location
		assembly = assembly_location.assembly
		assembly_location.destroy
		redirect_to(assembly)
	end
	
	private
	def validate_relation(assembly_location)
		Assembly.exists?(assembly_location.assembly) && Location.exists?(assembly_location.location) && assembly_location.save
	end
	
	def assembly_location_params
		params.require(:assembly_location).permit(:location_id, :assembly_id)
	end
	
	def is_valid_user
		redirect_to root_url unless current_user && current_user.allowed_to?(:assign_location_to_assembly)
	end
end
