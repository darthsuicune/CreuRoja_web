class VehicleAssembliesController < ApplicationController
	before_filter :signed_in_user
	before_filter :is_valid_user
		
	def create
		vehicle_assembly = VehicleAssembly.new(vehicle_assembly_params)
		log_action_result vehicle_assembly, vehicle_assembly.save
		redirect_to vehicle_assembly.vehicle, notice: I18n.t(:vehicle_assigned_to_assembly)
	end
	
	def update
		vehicle_assembly = VehicleAssembly.find(params[:id])
		log_action_result vehicle_assembly, vehicle_assembly.update(vehicle_assembly_params)
		redirect_to(vehicle_assembly.vehicle)
	end
	
	def destroy
		vehicle_assembly = VehicleAssembly.find(params[:id])
		log_action_result vehicle_assembly
		vehicle = vehicle_assembly.vehicle
		vehicle_assembly.destroy
		redirect_to(vehicle)
	end
	
	private
		def vehicle_assembly_params
			params.require(:vehicle_assembly).permit(:assembly_id, :vehicle_id)
		end
		def is_valid_user
			redirect_to root_url unless current_user && current_user.allowed_to?(:assign_users_to_assemblies)
		end
end
