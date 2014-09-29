class UserAssembliesController < ApplicationController
	before_filter :signed_in_user
	before_filter :is_valid_user
		
	def create
		@user_assembly = UserAssembly.new(user_assembly_params)
		if @user_assembly.save
			redirect_to @user_assembly.user, notice: I18n.t(:user_assigned_to_assembly)
		else
			redirect_to @user_assembly.user
		end
	end
	
	def update
		user_assembly = UserAssembly.find(params[:id])
		user_assembly.update(user_assembly_params)
		redirect_to(user_assembly.user)
	end
	
	def destroy
		user_assembly = UserAssembly.find(params[:id])
		user = user_assembly.user
		user_assembly.destroy
		redirect_to(user)
	end
	
	private
		def user_assembly_params
			params.require(:user_assembly).permit(:assembly_id, :user_id)
		end
		def is_valid_user
			redirect_to root_url unless current_user && current_user.allowed_to?(:assign_users_to_assemblies)
		end
end
