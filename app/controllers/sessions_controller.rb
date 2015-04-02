class SessionsController < ApplicationController
	def new
		redirect_to map_url if signed_in?
	end

	def create
		user = User.find_by_email(email)
		if log_action_result user, (user && user.active && user.authenticate(password))
			sign_in user
			respond_to do |format|
				format.html { redirect_back_or root_url }
				format.json { render :json => { token: @session, user: user.for_session } }
			end
		else
			respond_to do |format|
				format.html {
					flash.now[:error] = I18n.t(:error_invalid_login)
					render 'new'
				}
				format.json {
					render :json => "401", status: :unauthorized
				}
			end
		end
	end

	def destroy
		log_action_result current_user
		sign_out
		redirect_to root_url
	end
	
	private
		def email
			if params[:session]
				params[:session][:email].downcase
			elsif params
				params[:email]
			else 
				nil
			end
		end
		def password
			if params[:session]
				params[:session][:password]
			elsif params
				params[:password]
			else 
				nil
			end
		end
end
