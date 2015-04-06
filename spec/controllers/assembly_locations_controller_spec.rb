require 'rails_helper'

RSpec.describe AssemblyLocationsController, type: :controller do
	let(:user) { FactoryGirl.create(:user) }
	let(:admin) { FactoryGirl.create(:admin) }
	let(:assembly) { FactoryGirl.create(:assembly) }
	let(:location) { FactoryGirl.create(:location) }
	let(:new_location) { FactoryGirl.create(:location) }
	
	let(:create_options) { { assembly_location: { location_id: location.id, assembly_id: assembly.id } } }
	let(:invalid_create_options) { { assembly_location: { location_id: -1, assembly_id: assembly.id } } }
	let(:invalid_create_options_with_wrong_assembly) { { assembly_location: { location_id: location.id, assembly_id: -1 } } }
	let(:invalid_create_options_with_both_false_values)  { { assembly_location: { location_id: -1, assembly_id: -1 } } }
	
	describe "for admin works" do
		before { sign_in admin }

		describe "create" do
			describe "with valid params" do
				it "should redirect to the location after post create" do
					post :create, create_options
					expect(response).to redirect_to location
				end
				it "should create a relation" do
					expect{ post :create, create_options }.to change(AssemblyLocation, :count).by(1)
				end
			end
			describe "with invalid params" do
				it "should redirect to the assembly after post create if the assembly exists" do
					post :create, invalid_create_options
					expect(response).to redirect_to assembly
				end
				it "should redirect to the location after post create if the location exists" do
					post :create, invalid_create_options_with_wrong_assembly
					expect(response).to redirect_to location
				end
				it "should redirect to the assembly list after post create if neither exists" do
					post :create, invalid_create_options_with_both_false_values
					expect(response).to redirect_to assemblies_path
				end
				it "shouldn't create a relation" do
					expect{ post :create, invalid_create_options }.not_to change(AssemblyLocation, :count)
				end
			end
		end

		describe "update" do
			let(:al) { FactoryGirl.create(:assembly_location, assembly_id: assembly.id, location_id: location.id) }
			before { al.save }
			it "should redirect to root in put update" do
				put :update, { id: al.id, assembly_location: { location_id: new_location.id } }
				expect(response).to redirect_to new_location
			end
		end

		describe "delete" do 
			let(:al) { FactoryGirl.create(:assembly_location, assembly_id: assembly.id, location_id: location.id) }
			before { al.save }
			it "should redirect to root in delete destroy" do
				delete :destroy, { id: al.id }
				expect(response).to redirect_to assembly
			end
			it "should delete the relation" do
				expect{ delete :destroy, { id: al.id } }.to change(AssemblyLocation, :count).by(-1)
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
			let(:al) { FactoryGirl.create(:assembly_location, assembly_id: assembly.id, location_id: location.id) }
			before { al.save }
			it "should redirect to root in put update" do
				put :update, { id: al.id, assembly_location: { location_id: new_location.id } }
				expect(response).to redirect_to root_url
			end
		end

		describe "delete" do 
			let(:al) { FactoryGirl.create(:assembly_location, assembly_id: assembly.id, location_id: location.id) }
			before { al.save }
			it "should redirect to root in delete destroy" do
				delete :destroy, { id: al.id }
				expect(response).to redirect_to root_url
			end
			it "shouldn't delete the relation" do
				expect{ delete :destroy, { id: al.id } }.not_to change(AssemblyLocation, :count)
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
			let(:al) { FactoryGirl.create(:assembly_location, assembly_id: assembly.id, location_id: location.id) }
			before { al.save }
			it "should redirect to root in put update" do
				put :update, { id: al.id, assembly_location: { location_id: new_location.id } }
				expect(response).to redirect_to signin_url
			end
		end

		describe "delete" do 
			let(:al) { FactoryGirl.create(:assembly_location, assembly_id: assembly.id, location_id: location.id) }
			before { al.save }
			it "should redirect to root in delete destroy" do
				delete :destroy, { id: al.id }
				expect(response).to redirect_to signin_url
			end
			it "shouldn't delete the relation" do
				expect{ delete :destroy, { id: al.id } }.not_to change(AssemblyLocation, :count)
			end
		end
	end
end
