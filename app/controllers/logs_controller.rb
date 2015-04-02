class LogsController < ApplicationController
	before_filter :signed_in_user
	before_filter :is_valid_user
	
	def index
	end
	
	private 
	def is_valid_user
		redirect_to root_url unless current_user.allowed_to?(:see_logs)
	end
end
