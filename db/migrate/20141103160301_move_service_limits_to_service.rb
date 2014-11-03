class MoveServiceLimitsToService < ActiveRecord::Migration
	def change
		add_column :services, :doc, :integer, default: 0
		remove_column :location_services, :doc
		remove_column :vehicle_services, :doc
		
		add_column :services, :due, :integer, default: 0
		remove_column :location_services, :due
		remove_column :vehicle_services, :due
		
		add_column :services, :tes, :integer, default: 0
		remove_column :location_services, :tes
		remove_column :vehicle_services, :tes
		
		add_column :services, :ci, :integer, default: 0
		remove_column :location_services, :ci
		remove_column :vehicle_services, :ci
		
		add_column :services, :asi, :integer, default: 0
		remove_column :location_services, :asi
		remove_column :vehicle_services, :asi
		
		add_column :services, :btp, :integer, default: 0
		remove_column :location_services, :btp
		remove_column :vehicle_services, :btp
		
		add_column :services, :b1, :integer, default: 0
		remove_column :location_services, :b1
		remove_column :vehicle_services, :b1
		
		add_column :services, :acu, :integer, default: 0
		remove_column :location_services, :acu
		remove_column :vehicle_services, :acu
		
		add_column :services, :per, :integer, default: 0
		remove_column :location_services, :per
		remove_column :vehicle_services, :per
	end
end
