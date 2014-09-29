class AssemblyLocation < ActiveRecord::Base
	belongs_to :assembly
	belongs_to :location
	
	validates :assembly_id, presence: true
	validates :location_id, presence: true
end
