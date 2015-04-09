require 'rails_helper'

describe Service do
	let(:service) { FactoryGirl.create(:service) }
	
	subject { service }
	
	it { should respond_to(:name) }
	it { should respond_to(:assembly_id) }
	it { should respond_to(:base_time) }
	it { should respond_to(:start_time) }
	it { should respond_to(:end_time) }
	it { should respond_to(:vehicles) }
	
	describe "with invalid parameters" do
		let(:service) { Service.new(name: "asdf", assembly_id: 0, base_time: Time.now, start_time: Time.now, end_time: Time.now) }
		subject { service }
		
		describe "without name" do
			before { service.name = nil }
			it { should_not be_valid }
		end
		describe "without assembly_id" do
			before { service.assembly_id = nil }
			it { should_not be_valid }
		end
		describe "without base_time" do
			before { service.base_time = nil }
			it { should_not be_valid }
		end
		describe "without start_time" do
			before { service.start_time = nil }
			it { should_not be_valid }
		end
		describe "without end_time" do
			before { service.end_time = nil }
			it { should_not be_valid }
		end
	end
	
	describe "utility methods" do
		describe "add_location" do
			let(:location) { FactoryGirl.create(:location) }
			it "should increase the location counter" do
				expect{ service.add_location(location)}.to change(LocationService, :count).by(1)
			end
			it "should increase the service's location counter" do
				expect{ service.add_location(location)}.to change(service.locations, :count).by(1)
			end
		end
		
		describe "add_vehicle" do
			let(:vehicle) { FactoryGirl.create(:vehicle) }
			it "should increase the vehicle counter" do
				expect{ service.add_vehicle(vehicle)}.to change(VehicleService, :count).by(1)
			end
			it "should increase the service's vehicle counter" do
				expect{ service.add_vehicle(vehicle)}.to change(service.vehicles, :count).by(1)
			end
		end
		
		describe "add_user" do
			let(:user) { FactoryGirl.create(:user) }
			let(:location) { FactoryGirl.create(:location) }
			let(:vehicle) { FactoryGirl.create(:vehicle) }
			let(:position) { "position" }
			
			before do
				service.add_location location
				service.add_vehicle vehicle
			end
			
			it "should increase the ServiceUser count" do
				expect{ service.add_user(user, position)}.to change(ServiceUser, :count).by(1)
			end
			it "should increase the service's user counter" do
				expect{ service.add_user(user, position)}.to change(service.users, :count).by(1)
			end
			it "should allow for adding a user to a service+location" do
				expect{ service.add_user_to_location(user, position, location)}.to change(service.users, :count).by(1)
			end
			it "should allow for adding a user to a service+vehicle" do
				expect{ service.add_user_to_vehicle(user, position, vehicle)}.to change(service.users, :count).by(1)
			end
		end
		
		describe "first_location_id" do
			let(:location) { FactoryGirl.create(:location) }
			before { service.add_location location }
			it "should return the location id" do
				expect(service.first_location_id).to eq location.id
			end
		end
		
		describe "expired?" do
			it "should return true if the event ended before now" do
				service.end_time = 1.year.ago
				expect(service).to be_expired
			end
			it "should return false if the event ends in the future" do
				service.end_time = 1.year.from_now
				expect(service).not_to be_expired
			end
		end
		
		describe "in_base_time?" do
			before do
				service.base_time = 1.hour.ago
				service.start_time = 1.hour.from_now
			end
			it "should be true for services that are in the time frame" do
				expect(service).to be_in_base_time(Time.now)
			end
			it "should be false for services outside the time frame" do
				expect(service).not_to be_in_base_time(1.year.from_now)
				expect(service).not_to be_in_base_time(1.year.ago)
			end
		end
		
		describe "started?" do
			before do
				service.start_time = 1.hour.ago
				service.end_time = 1.hour.from_now
			end
			it "should be true for services that are in the time frame" do
				expect(service).to be_started(Time.now)
			end
			it "should be false for services outside the time frame" do
				expect(service).not_to be_started(1.year.from_now)
				expect(service).not_to be_started(1.year.ago)
			end
		end
		
		describe "finished?" do
			before { service.end_time = 1.hour.ago }
			
			it "should be true for services that ended before the passed time" do
				expect(service).to be_finished(Time.now)
				expect(service).to be_finished(1.year.from_now)
			end
			it "should be false for services that end after the passed time" do
				expect(service).not_to be_finished(1.year.ago)
			end
		end
		
		describe "self.last_date" do
			let(:future_date) { 15.years.from_now }
			before do
				service.end_time = future_date
				service.save
			end
			it "should return the last date in the database" do
				expect(Service.last_date).to be_within(1.second).of(future_date)
			end
		end
	end
end
