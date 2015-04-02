class AddRequestedParamToLog < ActiveRecord::Migration
	def change
		add_column :logs, :requested_param, :int
	end
end
