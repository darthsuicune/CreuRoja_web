# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
	factory :service_user do
		user_id 1
		service_id 1
		location_id 1
		vehicle_id 1
		user_position "something"
	end
end
