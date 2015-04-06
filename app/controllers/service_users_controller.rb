class ServiceUsersController < ApplicationController
	before_filter :signed_in_user
	before_filter :can_create, only: [:create]
	before_filter :is_valid_user, except: [:create]
	before_filter :is_valid_data, only: [:create, :update]
	
	def create
		service_user = ServiceUser.new(service_user_params)
		if log_action_result service_user, validate_relation(service_user)
			redirect_to service_user.service, notice: I18n.t(:user_assigned_to_service)
		else
			if Service.exists? service_user.service
				redirect_to service_user.service
			elsif User.exists? service_user.user
				redirect_to service_user.user
			else
				redirect_to services_path
			end
		end
	end

	def update
		service_user = ServiceUser.find(params[:id])
		log_action_result service_user, service_user.update(service_user_params)
		redirect_to service_user.service
	end

	def destroy
		service_user = ServiceUser.find(params[:id])
		log_action_result service_user
		service = service_user.service
		service_user.destroy
		redirect_to service
	end
	
	private
	def validate_relation(service_user)
		Service.exists?(service_user.service) && User.exists?(service_user.user) && service_user.save
	end
	
	def service_user_params
		params.require(:service_user).permit(:service_id, :user_id, :location_id, :vehicle_id, :user_position)
	end
	
	def is_valid_user
		redirect_to root_url unless has_permission?
	end
	
	def can_create
		redirect_to_root_url unless has_permission? || is_same_user
	end
	
	def has_permission?
		current_user.allowed_to?(:assign_user_to_service)
	end
	
	def is_same_user
		!params[:service_user].nil? && current_user?(User.find(params[:service_user][:user_id]))
	end
	
	def is_valid_data
		redirect_to_service_user.service if (Location.exists? params[:service_user][:location_id]) && (Vehicle.exists? params[:service_user][:vehicle_id])
	end
end
