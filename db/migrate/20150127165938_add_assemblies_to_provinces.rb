class AddAssembliesToProvinces < ActiveRecord::Migration
	def change
		add_column :provinces, :assembly_id, :integer
	end
end
