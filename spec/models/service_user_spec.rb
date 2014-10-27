require 'rails_helper'

RSpec.describe ServiceUser, :type => :model do
	let(:user) { FactoryGirl.create(:user) }
	let(:service) { FactoryGirl.create(:service) }
	let(:location) { FactoryGirl.create(:location) }
	let(:vehicle) { FactoryGirl.create(:vehicle) }
	let (:su) { ServiceUser.create(user_id: user.id, service_id: service.id, user_position: position) }
	let(:position) { "some position" }
	
	let(:service_user) { FactoryGirl.create(:service_user, user_id: user.id, service_id: service.id, user_position: position) }
	subject { service_user }
	
	it { should respond_to(:user) }
	it { should respond_to(:service) }
	it { should respond_to(:vehicle) }
	it { should respond_to(:location) }
	it { should respond_to(:user_position) }
	
	describe "created initially by the user" do
		
		it "should be valid" do
			expect(su).to be_valid
		end
	end
	
	describe "a technician can assign it to one of the locations or vehicles, but not to both" do		
		it "should allow for a location" do
			su.add_to_location location, position
			expect(su).to be_valid
		end
		
		it "should allow for a vehicle" do
			su.add_to_vehicle vehicle, position
			expect(su).to be_valid
		end
		
		it "should not allow for a location AND a vehicle" do
			su.location_id = location.id
			su.vehicle_id = vehicle.id
			expect(su).not_to be_valid
		end
	end
	
	describe "add_to_location" do
		before do
			su.add_to_vehicle vehicle, position
		end
		it "removes previous locations or vehicles" do
			su.add_to_location location, position
			expect(su.location).to eq location
			expect(su.vehicle).to be_nil
		end
	end
	
	describe "add_to_vehicle" do
		before do
			su.add_to_location location, position
		end
		it "removes previous locations or vehicles" do
			su.add_to_vehicle vehicle, position
			expect(su.location).to be_nil
			expect(su.vehicle).to eq vehicle
		end
	end
end
