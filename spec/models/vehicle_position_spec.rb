require 'rails_helper'

RSpec.describe VehiclePosition, :type => :model do
	let(:vehicle) { FactoryGirl.create(:vehicle) }
	let(:vp) { FactoryGirl.create(:vehicle_position, vehicle_id: vehicle.id) }
	
	describe "indicative" do
		it "should match the vehicle indicative" do
			expect(vp.indicative).to eq vehicle.indicative
		end
	end
end
