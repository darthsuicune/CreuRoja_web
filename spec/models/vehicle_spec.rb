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
		
		before {
			service.save
			user.save
			service_user.save
		}
		
		it "should output the service_user" do
			expect(vehicle.driver(service)).to eq(service_user)
		end
	end
	
	describe "moves to inoperative if itv is expired" do
		before do
			vehicle.itv = Date.yesterday
		end
		it "should stop being valid" do
			expect(vehicle).not_to be_available
		end
	end
	describe "moves to inoperative if sanitary_cert is expired" do
		before do
			vehicle.sanitary_cert = Date.yesterday
		end
		it "should stop being valid" do
			expect(vehicle).not_to be_available
		end
	end
end
