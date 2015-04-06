class LocationServicesController < ApplicationController
	before_filter :signed_in_user
	before_filter :is_valid_user
	
	def create
		location_service = LocationService.new(location_service_params)
		if log_action_result location_service, validate_relation(location_service)
			redirect_to location_service.service, notice: I18n.t(:service_assigned_to_location)
		else
			if Location.exists?(params[:location_service][:location_id])
				redirect_to location_service.location
			elsif Service.exists?(params[:location_service][:service_id])
				redirect_to location_service.service
			else
				redirect_to services_path
			end
		end
	end

	def update
		location_service = LocationService.find(params[:id])
		log_action_result location_service, location_service.update(location_service_params)
		redirect_to(location_service.service)
	end

	def destroy
		location_service = LocationService.find(params[:id])
		log_action_result location_service
		service = location_service.service
		location_service.destroy
		redirect_to(service)
	end
	
	private
	def validate_relation(location_service)
		Service.exists?(location_service.service) && Location.exists?(location_service.location) && location_service.save
	end
	
	def location_service_params
		params.require(:location_service).permit(:location_id, :service_id, :doc, :due, :tes, :ci, :asi, :btp, :b1, :acu, :per)
	end
	
	def is_valid_user
		redirect_to root_url unless current_user && current_user.allowed_to?(:assign_service_to_location)
	end
end
