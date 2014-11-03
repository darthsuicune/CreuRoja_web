class UserType < ActiveRecord::Base
	belongs_to :user
	
	validates :user_id, presence: true
	validates :user_type, presence: true
	
	def self.available_types(user = nil)
		if user
			where(user_id: user.id)
		else
			[[I18n.t(:asi), "asi"],
			[I18n.t(:acu), "acu"],
			[I18n.t(:tes), "tes"],
			[I18n.t(:due), "due"],
			[I18n.t(:doc), "doc"],
			[I18n.t(:b1), "b1"],
			[I18n.t(:btp), "btp"],
			[I18n.t(:d1), "d1"],
			[I18n.t(:per), "per"],
			[I18n.t(:ci), "ci"]]
		end
	end
end
