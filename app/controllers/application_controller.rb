class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	# Through https://coderwall.com/p/8z7z3a
	protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
	before_filter :log, only: [:create, :update, :destroy]
	before_filter :set_locale
	
	include SessionsHelper
	
	def default_url_options(options={})
		if params && params[:locale]
			{ locale: I18n.locale }
		else
			Rails.application.routes.default_url_options
		end
	end
	
	def not_found
		raise ActiveRecord::RecordNotFound.new('Not Found')
	end

	private
		def log
			unless controller_name == "vehicle_positions"
				user_id = (current_user) ? current_user.id : 0
				requested_param = (params && params[:id]) ? params[:id] : 0
				@log = Log.new(user_id: user_id, controller: controller_name, action: action_name, ip: request.remote_ip, requested_param: requested_param)
				@log.save
			end
		end
		
		def log_action_result(object, success = true)
			if @log
				@log.requested_param = object.id if object
				@log.action_success = success
				@log.user_id = current_user.id if current_user && @log.user_id == 0
				@log.save
			end
			success
		end
		
		def set_locale
			I18n.locale = params[:locale] || (current_user) ? current_user.language : I18n.default_locale
		end
end
