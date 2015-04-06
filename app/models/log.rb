class Log < ActiveRecord::Base
	default_scope { order(updated_at: :asc) }
	belongs_to :user
	
	validates :user_id, presence: true
	validates :action, presence: true
	validates :ip, presence: true
	validates :controller, presence: true
	
	def formatted_controller
		if controller.include?("_")
			"relation #{controller.split('_')[0]} #{controller.split('_')[1]}"
		else
			controller
		end
	end
	
	def translated_action(action_to_translate)
		#case action_to_translate...
		action_to_translate
	end
	
	def translated_controller(controller_to_translate)
		controller_to_translate
	end
	
	def link
		"#{controller}/#{requested_param}"
	end
	
	def has_link
		!controller.include?("_") && requested_param
	end
end
