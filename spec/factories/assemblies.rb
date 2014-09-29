# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
	factory :assembly do
		sequence(:name) { |n| "Name #{n}" }
		description "MyString"
		level "MyString"
		depends_on -1
		location_id 1
	end
end
