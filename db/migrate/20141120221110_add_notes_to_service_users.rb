class AddNotesToServiceUsers < ActiveRecord::Migration
	def change
		add_column :service_users, :notes, :string
	end
end
