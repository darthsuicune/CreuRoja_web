class Province < ActiveRecord::Base
	has_many :users
	has_many :locations
	has_one :assembly
end
