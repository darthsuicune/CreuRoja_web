# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
	factory :log do
		user_id 1
		action "MyString"
		controller "MyString"
		ip "MyString"
		action_success true
		requested_param 1
	end
end
