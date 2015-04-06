require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ServicesHelper. For example:
#
# describe ServicesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
describe ServicesHelper do
	let(:service1) { FactoryGirl.create(:service) }
	let(:service2) { FactoryGirl.create(:service) }
	
	describe "get_available_vehicles" do
		let(:vehicle1) { FactoryGirl.create(:vehicle) }
		let(:vehicle2) { FactoryGirl.create(:vehicle) }
		
		before do
			vehicle1.save
			vehicle2.save
			VehicleService.create!(service_id: service1.id, vehicle_id: vehicle1.id) 
		end
		
		it "should show only available vehicles" do
			expect(get_available_vehicles(service2)).to eq([[vehicle2.tag, vehicle2.id]])
		end
	end
	
	describe "get_available_locations" do
		let(:location1) { FactoryGirl.create(:location) }
		let(:location2) { FactoryGirl.create(:location) }
		
		before do
			location1.save
			location2.save
			LocationService.create!(service_id: service1.id, location_id: location1.id)
		end
		
		it "should not show already added locations" do
			expect(get_available_locations(service1)).to eq([[location2.name, location2.id]])
		end
		
		it "should show them for other services" do
			expect(get_available_locations(service2)).to eq([[location1.name, location1.id],[location2.name, location2.id]])
		end
	end
	
	describe "get_available_users" do
		let(:user1) { FactoryGirl.create(:user) }
		let(:user2) { FactoryGirl.create(:user) }

		before do
			user1.save
			user2.save
			ServiceUser.create!(service_id: service1.id, user_id: user1.id, user_position: "something")
		end
		
		it "should not show busy users" do
			expect(get_available_users(service2)).to eq([[user2.full_name, user2.id]])
		end
	end
	
	describe "locations_for_user_service" do
		let(:location1) { FactoryGirl.create(:location) }
		
		before do
			location1.save
			LocationService.create!(service_id: service1.id, location_id: location1.id)
		end
		
		it "should properly format the locations and add a 'null' option for vehicle" do
			expect(locations_for_user_service(service1.locations)).to eq([["Vehicle", -1], [location1.name, location1.id]])
		end
	end
	
	
	
	describe "vehicles_for_user_service" do
		let(:vehicle1) { FactoryGirl.create(:vehicle) }
		
		before do
			vehicle1.save
			VehicleService.create!(service_id: service1.id, vehicle_id: vehicle1.id)
		end
		
		it "should properly format the location and add a 'null' option for location" do
			expect(vehicles_for_user_service(service1.vehicles)).to eq([["Location", -1],[vehicle1.indicative, vehicle1.id]])
		end
	end
end
