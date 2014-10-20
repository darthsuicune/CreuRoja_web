# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
	factory :service do
		sequence(:name) { |n| "Name #{n}" }
		sequence(:description) { |n| "Description #{n}" }
		assembly_id 1
		base_time Time.now.to_s
		start_time Time.now.to_s
		end_time 1.month.from_now
		code "MyCode"
	end
end
