require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe VehiclesController do

  # This should return the minimal set of attributes required to create a valid
  # Vehicle. As you add validations to Vehicle, be sure to
  # adjust the attributes here as well.
	let(:valid_attributes) { { "brand" => "MyString", "model" => "Model", "license" => "License",
										"vehicle_type" => "type", "places" => 5, "operative" => true,
	                           "indicative" => "Indicative", "itv" => Date.today.to_s, 
	                           "sanitary_cert" => Date.today.to_s } }

	# This should return the minimal set of values that should be in the session
	# in order to pass any filters (e.g. authentication) defined in
	# VehiclesController. Be sure to keep this updated too.
	let(:valid_session) { {} }


	describe "without signin in" do
		subject { page }
		describe "index" do
			before { get :index, {}, valid_session }
			it { should redirect_to(signin_url) }
		end
		describe "show" do
			before { get :show, {:id => 0}, valid_session }
			it { should redirect_to(signin_url) }
		end
		describe "new" do
			before { get :new, {}, valid_session }
			it { should redirect_to(signin_url) }
		end
		describe "edit" do
			before { get :edit, {:id => 0}, valid_session }
			it { should redirect_to(signin_url) }
		end
		describe "create" do
			before { post :create, {:vehicle => valid_attributes}, valid_session }
			it { should redirect_to(signin_url) }
		end
		describe "update" do
			before { put :update, {:id => 0, :vehicle => { "brand" => "MyString" }}, valid_session }
			it { should redirect_to(signin_url) }
		end
		describe "destroy" do
			before { delete :destroy, {:id => 0}, valid_session }
			it { should redirect_to(signin_url) }
		end
	end
	
	describe "signed in" do
		let(:admin) { FactoryGirl.create(:admin) }
		let(:vehicle) { FactoryGirl.create(:vehicle) }
		before { sign_in admin }

		describe "GET index" do
			it "assigns all vehicles as @vehicles" do
				get :index, {}, valid_session
				expect(assigns(:vehicles)).to eq([vehicle])
			end
		end

		describe "GET show" do
			it "assigns the requested vehicle as @vehicle" do
				get :show, {:id => vehicle.to_param}, valid_session
				expect(assigns(:vehicle)).to eq(vehicle)
			end
		end

		describe "GET new" do
			it "assigns a new vehicle as @vehicle" do
				get :new, {}, valid_session
				expect(assigns(:vehicle)).to be_a_new(Vehicle)
			end
		end

		describe "GET edit" do
			it "assigns the requested vehicle as @vehicle" do
				get :edit, {:id => vehicle.to_param}, valid_session
				expect(assigns(:vehicle)).to eq(vehicle)
			end
		end

		describe "POST create" do
			describe "with valid params" do
				it "creates a new Vehicle" do
					expect {
						post :create, {:vehicle => valid_attributes}, valid_session
					}.to change(Vehicle, :count).by(1)
				end

				it "assigns a newly created vehicle as @vehicle" do
					post :create, {:vehicle => valid_attributes}, valid_session
					expect(assigns(:vehicle)).to be_a(Vehicle)
					expect(assigns(:vehicle)).to be_persisted
				end

				it "redirects to the created vehicle" do
					post :create, {:vehicle => valid_attributes}, valid_session
					expect(response).to redirect_to(Vehicle.last)
				end
				
				it "sets correctly the itv and sanitary_cert dates" do
					post :create, {:vehicle => valid_attributes}, valid_session
					expect(assigns(:vehicle).itv).to eq(Date.today)
					expect(assigns(:vehicle).sanitary_cert).to eq(Date.today)
				end
			end

			describe "with invalid params" do
				it "assigns a newly created but unsaved vehicle as @vehicle" do
					# Trigger the behavior that occurs when invalid params are submitted
					expect_any_instance_of(Vehicle).to receive(:save).and_return(false)
					post :create, {:vehicle => { "brand" => "invalid value" }}, valid_session
					expect(assigns(:vehicle)).to be_a_new(Vehicle)
				end

				it "re-renders the 'new' template" do
					# Trigger the behavior that occurs when invalid params are submitted
					expect_any_instance_of(Vehicle).to receive(:save).and_return(false)
					post :create, {:vehicle => { "brand" => "invalid value" }}, valid_session
					expect(response).to render_template("new")
				end
			end
		end

		describe "PUT update" do
			describe "with valid params" do
				it "updates the requested vehicle" do
					# Assuming there are no other vehicles in the database, this
					# specifies that the Vehicle created on the previous line
					# receives the :update_attributes message with whatever params are
					# submitted in the request.
					allow_any_instance_of(Vehicle).to receive(:update).with({ "brand" => "MyString" })
					put :update, {:id => vehicle.to_param, :vehicle => { "brand" => "MyString" }}, valid_session
				end

				it "assigns the requested vehicle as @vehicle" do
					put :update, {:id => vehicle.to_param, :vehicle => valid_attributes}, valid_session
					expect(assigns(:vehicle)).to eq(vehicle)
				end

				it "redirects to the vehicle" do
					put :update, {:id => vehicle.to_param, :vehicle => valid_attributes}, valid_session
					expect(response).to redirect_to(vehicle)
				end
			end

			describe "with invalid params" do
				it "assigns the vehicle as @vehicle" do
					# Trigger the behavior that occurs when invalid params are submitted
					expect_any_instance_of(Vehicle).to receive(:save).and_return(false)
					put :update, {:id => vehicle.to_param, :vehicle => { "brand" => "invalid value" }}, valid_session
					expect(assigns(:vehicle)).to eq(vehicle)
				end

				it "re-renders the 'edit' template" do
					# Trigger the behavior that occurs when invalid params are submitted
					expect_any_instance_of(Vehicle).to receive(:save).and_return(false)
					put :update, {:id => vehicle.to_param, :vehicle => { "brand" => "invalid value" }}, valid_session
					expect(response).to render_template("edit")
				end
			end
		end

		describe "DELETE destroy" do
			before { @vehicle = vehicle }
			
			it "destroys the requested vehicle" do
				expect {
					delete :destroy, {id: @vehicle.to_param}, valid_session
				}.to change(Vehicle, :count).by(-1)
			end

			it "redirects to the vehicles list" do
				delete :destroy, {id: @vehicle.to_param}, valid_session
				expect(response).to redirect_to(vehicles_url)
			end
		end
	end
	
	describe "signed in as technician" do
		let(:tech) { FactoryGirl.create(:tech) }
		let(:vehicle) { FactoryGirl.create(:vehicle) }
		let(:vehicle1) { FactoryGirl.create(:vehicle) }
		let(:assembly) { FactoryGirl.create(:assembly) }
		
		before do
			sign_in tech 
			tech.add_to_assembly(assembly)
			vehicle.add_to_assembly(assembly)
		end
		
		it "doesn't assign vehicles that are outside the assembly" do
			get :index, {}, valid_session
			expect(assigns(:vehicles)).not_to include vehicle1
		end
		it "assigns the requested vehicle as @vehicle" do
			get :show, {:id => vehicle.id}, valid_session
			expect(assigns(:vehicle)).to eq(vehicle)
		end
		
	end
end
