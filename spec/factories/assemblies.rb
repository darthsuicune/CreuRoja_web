# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
	factory :assembly do
		sequence(:name) { |n| "Name #{n}" }
		description "MyString"
		level "MyString"
		location_id 1
	
		factory :estatal do 
			level "estatal"
		end
		factory :autonomica do
			level "autonomica"
		end
		factory :provincial do
			level "provincial"
		end
		factory :comarcal do
			level "comarcal"
		end
		factory :local do
			level "local"
		end
		factory :delegation do
			level "delegation"
		end
	end
end
