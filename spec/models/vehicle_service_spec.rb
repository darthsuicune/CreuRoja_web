require 'rails_helper'

describe VehicleService do
	let(:vehicle_service) { FactoryGirl.create(:vehicle_service) }
	it { should respond_to(:vehicle) }
	it { should respond_to(:service) }
end
