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
				position = VehiclePosition.new(vehicle_positions_params)
				if position.save
					head :created 
				else
					head :bad_request 
				end
			end
		end
	end
	
	private
	def vehicle_positions_params
		params[:vehicle_position] = JSON::parse(params[:vehicle_position]) if params[:vehicle_position]
		params.require(:vehicle_position).permit(:vehicle_id, :latitude, :longitude)
		
	end
	
	def is_valid_user
		redirect_to root_url unless current_user && current_user.allowed_to?(:manage_vehicles)
	end
end
