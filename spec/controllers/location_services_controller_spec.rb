require 'rails_helper'

RSpec.describe LocationServicesController, type: :controller do
	let(:user) { FactoryGirl.create(:user) }
	let(:admin) { FactoryGirl.create(:admin) }
	let(:service) { FactoryGirl.create(:service) }
	let(:location) { FactoryGirl.create(:location) }
	let(:new_location) { FactoryGirl.create(:location) }
	
	let(:create_options) { { location_service: { location_id: location.id, service_id: service.id } } }
	let(:invalid_create_options) { { location_service: { location_id: -1, service_id: service.id } } }
	let(:invalid_create_options_with_wrong_service) { { location_service: { location_id: location.id, service_id: -1 } } }
	let(:invalid_create_options_with_both_false_values)  { { location_service: { location_id: -1, service_id: -1 } } }
	
	describe "for admin works" do
		before { sign_in admin }

		describe "create" do
			describe "with valid params" do
				it "should redirect to the location after post create" do
					post :create, create_options
					expect(response).to redirect_to service
				end
				it "should create a relation" do
					expect{ post :create, create_options }.to change(LocationService, :count).by(1)
				end
			end
			describe "with invalid params" do
				it "should redirect to the service after post create if the service exists" do
					post :create, invalid_create_options
					expect(response).to redirect_to service
				end
				it "should redirect to the location after post create if the location exists" do
					post :create, invalid_create_options_with_wrong_service
					expect(response).to redirect_to location
				end
				it "should redirect to the service list after post create if neither exists" do
					post :create, invalid_create_options_with_both_false_values
					expect(response).to redirect_to services_path
				end
				it "shouldn't create a relation" do
					expect{ post :create, invalid_create_options }.not_to change(LocationService, :count)
				end
			end
		end

		describe "update" do
			let(:ls) { FactoryGirl.create(:location_service, service_id: service.id, location_id: location.id) }
			before { ls.save }
			it "should redirect to root in put update" do
				put :update, { id: ls.id, location_service: { location_id: new_location.id } }
				expect(response).to redirect_to service
			end
		end

		describe "delete" do 
			let(:ls) { FactoryGirl.create(:location_service, service_id: service.id, location_id: location.id) }
			before { ls.save }
			it "should redirect to root in delete destroy" do
				delete :destroy, { id: ls.id }
				expect(response).to redirect_to service
			end
			it "should delete the relation" do
				expect{ delete :destroy, { id: ls.id } }.to change(LocationService, :count).by(-1)
			end
		end
	end

	describe "for a regular user won't work or modify anything" do
		before { sign_in user }
		
		describe "create" do
			it "should redirect to root in post create" do
				post :create, create_options
				expect(response).to redirect_to root_url
			end
		end

		describe "update" do
			let(:ls) { FactoryGirl.create(:location_service, service_id: service.id, location_id: location.id) }
			before { ls.save }
			it "should redirect to root in put update" do
				put :update, { id: ls.id, location_service: { location_id: new_location.id } }
				expect(response).to redirect_to root_url
			end
		end

		describe "delete" do 
			let(:ls) { FactoryGirl.create(:location_service, service_id: service.id, location_id: location.id) }
			before { ls.save }
			it "should redirect to root in delete destroy" do
				delete :destroy, { id: ls.id }
				expect(response).to redirect_to root_url
			end
			it "shouldn't delete the relation" do
				expect{ delete :destroy, { id: ls.id } }.not_to change(LocationService, :count)
			end
		end
	end

	

	describe "without login in won't work or modify anything" do
		describe "create" do
			it "should redirect to root in post create" do
				post :create, create_options
				expect(response).to redirect_to signin_url
			end
		end

		describe "update" do
			let(:ls) { FactoryGirl.create(:location_service, service_id: service.id, location_id: location.id) }
			before { ls.save }
			it "should redirect to root in put update" do
				put :update, { id: ls.id, location_service: { location_id: new_location.id } }
				expect(response).to redirect_to signin_url
			end
		end

		describe "delete" do 
			let(:ls) { FactoryGirl.create(:location_service, service_id: service.id, location_id: location.id) }
			before { ls.save }
			it "should redirect to root in delete destroy" do
				delete :destroy, { id: ls.id }
				expect(response).to redirect_to signin_url
			end
			it "shouldn't delete the relation" do
				expect{ delete :destroy, { id: ls.id } }.not_to change(LocationService, :count)
			end
		end
	end
end
