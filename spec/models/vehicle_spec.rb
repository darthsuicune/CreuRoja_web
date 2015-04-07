require 'rails_helper'

describe Vehicle do
	let(:vehicle) { FactoryGirl.create(:vehicle) }
	subject { vehicle }
	
	it { should respond_to(:brand) }
	it { should respond_to(:model) }
	it { should respond_to(:license) }
	it { should respond_to(:vehicle_type) }
	it { should respond_to(:places) }
	it { should respond_to(:services) }
	it { should respond_to(:assemblies) }
	it { should respond_to(:itv) }
	it { should respond_to(:sanitary_cert) }
	
	describe "driver" do
		let(:service) { FactoryGirl.create(:service) }
		let(:user) { FactoryGirl.create(:user) }
		let(:service_user) { FactoryGirl.create(:service_user, service_id: service.id, vehicle_id:vehicle.id, user_id: user.id, user_position: "b1") }
		
		before do
			service.save
			user.save
			service_user.save
		end
		
		it "should output the service_user" do
			expect(vehicle.driver(service)).to eq(service_user)
		end
	end
	
	describe "moves to inoperative if itv is expired" do
		before { vehicle.itv = Date.yesterday }
		it "should stop being valid" do
			expect(vehicle).not_to be_available
		end
	end
	describe "moves to inoperative if sanitary_cert is expired" do
		before { vehicle.sanitary_cert = Date.yesterday }
		it "should stop being valid" do
			expect(vehicle).not_to be_available
		end
	end
	
	describe "to_s" do
		it "should match the indicative" do
			expect(vehicle.to_s).to eq vehicle.indicative
		end
	end
	
	describe "tag" do
		it "should format an identification" do
			expect(vehicle.tag).to eq "#{vehicle.indicative}, #{vehicle.license}"
		end
	end
	
	describe "add_to_service" do
		let(:service) { FactoryGirl.create(:service) }
		it "should increase the VehicleService count" do
			expect{ vehicle.add_to_service(service) }.to change(VehicleService, :count).by(1)
		end
		it "should increase the own services count" do
			expect{ vehicle.add_to_service(service) }.to change(vehicle.services, :count).by(1)
		end
		
		describe "user to vehicle in service" do
			let(:user) { FactoryGirl.create(:user) }
			let(:position) { "position" }
			it "should increase the ServiceUser count" do
				expect{ vehicle.add_user_to_service_in_vehicle(user, service, position) }.to change(ServiceUser, :count).by(1)
			end
			it "should increase the service users count" do
				expect{ vehicle.add_user_to_service_in_vehicle(user, service, position) }.to change(service.users, :count).by(1)
			end
		end
	end
	
	describe "translated vehicle type" do
		let(:alfa_bravo) { "alfa bravo" }
		let(:alfa_mike) { "alfa mike" }
		let(:mike) { "mike" }
		let(:romeo) { "romeo" }
		let(:tango) { "tango" }
		
		it "should return the translated string" do
			vehicle.vehicle_type = alfa_bravo
			expect(vehicle.translated_vehicle_type).to eq I18n.t(:vehicle_type_alfa_bravo)
		end
		it "should return the translated string" do
			vehicle.vehicle_type = alfa_mike
			expect(vehicle.translated_vehicle_type).to eq I18n.t(:vehicle_type_alfa_mike)
		end
		it "should return the translated string" do
			vehicle.vehicle_type = mike
			expect(vehicle.translated_vehicle_type).to eq I18n.t(:vehicle_type_mike)
		end
		it "should return the translated string" do
			vehicle.vehicle_type = romeo
			expect(vehicle.translated_vehicle_type).to eq I18n.t(:vehicle_type_romeo)
		end
		it "should return the translated string" do
			vehicle.vehicle_type = tango
			expect(vehicle.translated_vehicle_type).to eq I18n.t(:vehicle_type_tango)
		end
	end
end
