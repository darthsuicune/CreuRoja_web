module LogsHelper
	def can_see_logs_of?(log_user)
		!log_user.nil? && current_user.in_assembly_of?(log_user)
	end
end
