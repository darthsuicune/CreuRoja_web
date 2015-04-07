require 'rails_helper'

RSpec.describe VehiclePositionsController, :type => :controller do
	let(:admin) { FactoryGirl.create(:admin) }
	let(:vehicle) { FactoryGirl.create(:vehicle) }
	let(:vehicle1) { FactoryGirl.create(:vehicle) }
	
	let(:values) { { vehicle_id: vehicle.id, latitude: 1, longitude: 1 } }
	let(:invalid_values) { { vehicle_id: -1, latitude: 1, longitude: 1 } }
	
	let(:valid_create_data) { { vehicle_position: values, format: :json } }
	let(:invalid_create_data) { { vehicle_position: invalid_values, format: :json } }
	
	before do 
		sign_in admin
		vehicle.update_position(2, 3)
		vehicle1.update_position(4, 5)
	end
	
	describe "GET index" do
		it "returns http success" do
			get :index
			expect(response).to be_success
		end
		
		it "assigns @locations to the last known position of each vehicle" do
			get :index
			expect(assigns(:vehicles)).to eq [vehicle.last_position, vehicle1.last_position]
		end
	end

	describe "POST create" do
		before { vehicle.update_position 1, 1 }
		
		describe "on html requests" do
			before { post :create, { vehicle_position: values } }
			it "doesn't update the data" do
				expect{ post :create, { vehicle_position: values } }.not_to change(VehiclePosition, :count)
			end
			it "sends an unauthorized header" do
				expect(response.code).to eq "401"
			end
		end
		describe "on json requests" do
			describe "with valid data" do
				it "returns http success" do
					post :create, valid_create_data
					expect(response).to be_success
				end
				it "increases the VehiclePosition count" do
					expect{ post :create, valid_create_data }.to change(VehiclePosition, :count).by(1)
				end
				it "saves the vehicle position" do
					post :create, valid_create_data
					expect(vehicle.last_position.latitude).to eq 1
					expect(vehicle.last_position.longitude).to eq 1
				end
			end
			describe "with invalid data" do
				it "returns http success" do
					post :create, invalid_create_data
					expect(response).not_to be_success
				end
				it "increases the VehiclePosition count" do
					expect{ post :create, invalid_create_data }.not_to change(VehiclePosition, :count)
				end
				it "saves the vehicle position" do
					post :create, invalid_create_data
					expect(response).to be_bad_request
				end
			end
		end
	end

end
