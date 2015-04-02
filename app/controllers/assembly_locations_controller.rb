class AssemblyLocationsController < ApplicationController
	before_filter :signed_in_user
	before_filter :is_valid_user, only: [:create, :update, :destroy]
	
	def create
		assembly_location = AssemblyLocation.new(assembly_location_params)
		if log_action_result assembly_location, assembly_location.save
			redirect_to assembly_location.location, notice: I18n.t(:location_assigned_to_assembly)
		else
			redirect_to assembly_location.location
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
	def assembly_location_params
		params.require(:assembly_location).permit(:location_id, :assembly_id)
	end
	
	def is_valid_user
		redirect_to root_url unless current_user && current_user.allowed_to?(:assign_location_to_assembly)
	end
end
