class AddActionResultToLog < ActiveRecord::Migration
	def change
		add_column :logs, :action_success, :boolean, default: true
	end
end
