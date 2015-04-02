class AssembliesController < ApplicationController
	before_filter :signed_in_user
	before_filter :is_valid_user
	before_filter :set_assembly, only: [:show, :edit, :update, :destroy]
	
	def index
		@assemblies = Assembly.all
	end

	def new
		@assembly = Assembly.new
	end

	def create
		@assembly = Assembly.new(assembly_params)
		verify_parent(@assembly)
		if log_action_result @assembly, @assembly.save
			redirect_to @assembly
		else
			render 'new'
		end
	end

	def show
	end

	def edit
	end

	def update
		verify_parent(@assembly)
		log_action_result @assembly, @assembly.update(assembly_params)
		redirect_to @assembly
	end

	def destroy
		log_action_result @assembly
		@assembly.destroy
		redirect_to assemblies_url
	end
	
	private
		
		def assembly_params
			params.require(:assembly).permit(:name, :description, :level, :location_id, :depends_on)
		end
		
		def is_valid_user
			redirect_to root_url unless current_user.allowed_to?(:manage_assemblies)
		end
		
		def set_assembly
			@assembly = Assembly.find(params[:id])
		end
		
		def verify_parent(assembly)
			if assembly.depends_on == "-" || assembly.depends_on == 0
				assembly.depends_on = nil
			end
		end
end
