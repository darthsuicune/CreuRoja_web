# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
	factory :assembly do
		name "MyString"
		description "MyString"
		level "MyString"
		depends_on 1
	end
end
