class AssemblyLocation < ActiveRecord::Base
	belongs_to :assembly
	belongs_to :location
	
	validates :assembly_id, presence: true
	validates :location_id, presence: true
	
	before_save :notify_location_update
	
	private
	def notify_location_update
		location.updated_at = Time.now
		location.save
	end
end
