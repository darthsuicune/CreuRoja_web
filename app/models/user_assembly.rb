class UserAssembly < ActiveRecord::Base
	belongs_to :user
	belongs_to :assembly
	
	validates :user_id, presence: true
	validates :assembly_id, presence: true
end
