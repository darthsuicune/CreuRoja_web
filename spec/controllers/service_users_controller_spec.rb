require 'rails_helper'

RSpec.describe ServiceUsersController, type: :controller do
	let(:user) { FactoryGirl.create(:user) }
	let(:admin) { FactoryGirl.create(:admin) }
	let(:service) { FactoryGirl.create(:service) }
	let(:location) { FactoryGirl.create(:location) }
	let(:vehicle) { FactoryGirl.create(:vehicle) }
	let(:new_user) { FactoryGirl.create(:user) }
	
	let(:create_options) { { service_user: { user_id: user.id, service_id: service.id, user_position: "position" } } }
	let(:invalid_create_options) { { service_user: { user_id: -1, service_id: service.id, user_position: "position" } } }
	let(:invalid_create_options_with_wrong_service) { { service_user: { user_id: user.id, service_id: -1, user_position: "position" } } }
	let(:invalid_create_options_with_both_false_values)  { { service_user: { user_id: -1, service_id: -1, user_position: "position" } } }
	
	describe "for admin works" do
		before { sign_in admin }

		describe "create" do
			describe "with valid params" do
				it "should redirect to the user after post create" do
					post :create, create_options
					expect(response).to redirect_to service
				end
				it "should create a relation" do
					expect{ post :create, create_options }.to change(ServiceUser, :count).by(1)
				end
			end
			describe "with invalid params" do
				it "should redirect to the service after post create if the service exists" do
					post :create, invalid_create_options
					expect(response).to redirect_to service
				end
				it "should redirect to the user after post create if the user exists" do
					post :create, invalid_create_options_with_wrong_service
					expect(response).to redirect_to user
				end
				it "should redirect to the service list after post create if neither exists" do
					post :create, invalid_create_options_with_both_false_values
					expect(response).to redirect_to services_path
				end
				it "shouldn't create a relation" do
					expect{ post :create, invalid_create_options }.not_to change(ServiceUser, :count)
				end
			end
		end

		describe "update" do
			let(:su) { FactoryGirl.create(:service_user, service_id: service.id, user_id: user.id) }
			before { su.save }
			it "should redirect to root in put update" do
				put :update, { id: su.id, service_user: { user_id: new_user.id } }
				expect(response).to redirect_to service
			end
		end

		describe "delete" do 
			let(:su) { FactoryGirl.create(:service_user, service_id: service.id, user_id: user.id) }
			before { su.save }
			it "should redirect to root in delete destroy" do
				delete :destroy, { id: su.id }
				expect(response).to redirect_to service
			end
			it "should delete the relation" do
				expect{ delete :destroy, { id: su.id } }.to change(ServiceUser, :count).by(-1)
			end
		end
	end

	describe "for a regular user" do
		before { sign_in user }
		
		describe "create is allowed" do
			it "should allow him to sign up to the service" do
				expect{ post :create, create_options }.to change(ServiceUser, :count).by(1)
			end
			it "should redirect the user to the service page" do
				post :create, create_options
				expect(response).to redirect_to service
			end
		end

		describe "update is not allowed" do
			let(:su) { FactoryGirl.create(:service_user, service_id: service.id, user_id: user.id) }
			before { su.save }
			it "should redirect to root in put update" do
				put :update, { id: su.id, service_user: { user_id: new_user.id } }
				expect(response).to redirect_to root_url
			end
		end

		describe "delete is not allowed" do 
			let(:su) { FactoryGirl.create(:service_user, service_id: service.id, user_id: user.id) }
			before { su.save }
			it "should redirect to root in delete destroy" do
				delete :destroy, { id: su.id }
				expect(response).to redirect_to root_url
			end
			it "shouldn't delete the relation" do
				expect{ delete :destroy, { id: su.id } }.not_to change(ServiceUser, :count)
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
			let(:su) { FactoryGirl.create(:service_user, service_id: service.id, user_id: user.id) }
			before { su.save }
			it "should redirect to root in put update" do
				put :update, { id: su.id, service_user: { user_id: new_user.id } }
				expect(response).to redirect_to signin_url
			end
		end

		describe "delete" do 
			let(:su) { FactoryGirl.create(:service_user, service_id: service.id, user_id: user.id) }
			before { su.save }
			it "should redirect to root in delete destroy" do
				delete :destroy, { id: su.id }
				expect(response).to redirect_to signin_url
			end
			it "shouldn't delete the relation" do
				expect{ delete :destroy, { id: su.id } }.not_to change(ServiceUser, :count)
			end
		end
	end
end
