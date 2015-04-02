class UserAssembliesController < ApplicationController
	before_filter :signed_in_user
	before_filter :set_user_assembly, only: [:update, :destroy]
	before_filter :is_valid_user
		
	def create
		@user_assembly = UserAssembly.new(user_assembly_params)
		log_action_result @user_assembly, @user_assembly.save
		redirect_to @user_assembly.user, notice: I18n.t(:user_assigned_to_assembly)
	end
	
	def update
		log_action_result @user_assembly, @user_assembly.update(user_assembly_params)
		redirect_to(@user_assembly.user)
	end
	
	def destroy
		user = @user_assembly.user
		log_action_result @user_assembly
		@user_assembly.destroy
		redirect_to(user)
	end
	
	private
		def set_user_assembly
			@user_assembly = UserAssembly.find(params[:id])
		end
		
		def user_assembly_params
			params.require(:user_assembly).permit(:assembly_id, :user_id)
		end
		
		def is_valid_user
			redirect_to root_url unless current_user && current_user.allowed_to?(:assign_users_to_assemblies)
		end
end
