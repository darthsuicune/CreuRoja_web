class VehiclePositionsController < ApplicationController
	before_filter :signed_in_user
	before_filter :is_valid_user
	
	def index
		vehicle_list = VehiclePosition.select(:vehicle_id).distinct
		@vehicles = []
		vehicle_list.each do |vehicle|
			@vehicles << vehicle.last_position
		end
		@vehicles
	end

	def create
		respond_to do |format|
			format.html { head :unauthorized  }
			format.json do
				position = VehiclePosition.new(vehicle_id: parse_id, latitude: parse_lat, longitude: parse_long)
				if position.save
					head :created 
				else
					head :bad_request 
				end
			end
		end
	end
	
	private
	def parse_id
		if params[:vehicle_position]
			params[:vehicle_position][:vehicle_id]
		elsif params
			params[:vehicle_id]
		end
	end
	
	def parse_lat
		if params[:vehicle_position]
			params[:vehicle_position][:latitude]
		elsif params
			params[:latitude]
		end
	end
	
	def parse_long
		if params[:vehicle_position]
			params[:vehicle_position][:longitude]
		elsif params
			params[:longitude]
		end
	end
	
	def is_valid_user
		redirect_to root_url unless current_user && current_user.allowed_to?(:manage_vehicles)
	end
end
