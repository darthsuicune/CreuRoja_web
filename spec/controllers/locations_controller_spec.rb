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
# to receives and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe LocationsController do

	# This should return the minimal set of attributes required to create a valid
	# Location. As you add validations to Location, be sure to
	# adjust the attributes here as well.
	let(:valid_attributes) { { "name" => "MyString", "address" => "Address", "latitude" => 1.5,
											"longitude" => 1.5, "location_type" => "type" } }

	# This should return the minimal set of values that should be in the session
	# in order to pass any filters (e.g. authentication) defined in
	# LocationsController. Be sure to keep this updated too.
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
			before { post :create, {location: valid_attributes}, valid_session }
			it { should redirect_to(signin_url) }
		end
		describe "update" do
			before { put :update, {id: 0, location: { "name" => "MyString" }}, valid_session }
			it { should redirect_to(signin_url) }
		end
		describe "destroy" do
			before { delete :destroy, {id: 0}, valid_session }
			it { should redirect_to(signin_url) }
		end
	end
	
	describe "signed in" do
		describe "as admin" do
			let(:user) { FactoryGirl.create(:admin) }
			let(:location) { FactoryGirl.create(:location) }
			before { sign_in user }

			describe "GET index" do
				it "assigns all locations as @locations" do
					get :index, {}, valid_session
					expect(assigns(:locations)).to match_array([location])
				end
			end

			describe "GET show" do
				it "assigns the requested location as @location" do
					get :show, {:id => location.to_param}, valid_session
					expect(assigns(:location)).to eq(location)
				end
			end

			describe "GET new" do
				it "assigns a new location as @location" do
					get :new, {}, valid_session
					expect(assigns(:location)).to be_a_new(Location)
				end
			end

			describe "GET edit" do
				it "assigns the requested location as @location" do
					get :edit, {:id => location.to_param}, valid_session
					expect(assigns(:location)).to eq(location)
				end
			end

			describe "GET map" do
				it "shows the map" do
					get :map
					expect(response.status).to eq(200)
				end
			end

			describe "POST create" do
				describe "with valid params" do
					it "creates a new Location" do
						expect {
							post :create, {:location => valid_attributes}, valid_session
						}.to change(Location, :count).by(1)
					end

					it "assigns a newly created location as @location" do
						post :create, {:location => valid_attributes}, valid_session
						expect(assigns(:location)).to be_a(Location)
						expect(assigns(:location)).to be_persisted
					end

					it "redirects to the created location" do
						post :create, {:location => valid_attributes}, valid_session
						expect(response).to redirect_to(Location.last)
					end
				end

				describe "with invalid params" do
					it "assigns a newly created but unsaved location as @location" do
						# Trigger the behavior that occurs when invalid params are submitted
						allow_any_instance_of(Location).to receive(:save).and_return(false)
						post :create, {:location => { "name" => "invalid value" }}, valid_session
						expect(assigns(:location)).to be_a_new(Location)
					end

					it "re-renders the 'new' template" do
						# Trigger the behavior that occurs when invalid params are submitted
						allow_any_instance_of(Location).to receive(:save).and_return(false)
						post :create, {:location => { "name" => "invalid value" }}, valid_session
						expect(response).to render_template("new")
					end
				end
				describe "with ,s instead of .s for decimal points" do
					let(:comma_attrs) { { "name" => "MyString", "address" => "Address", "latitude" => "43,21",
											"longitude" => "12,34", "location_type" => "type" } }
					before { @initial_value = "1,5" }
					it "creates a correct location" do
						post :create, {location: comma_attrs }, valid_session
						expect(assigns(:location)).to be_a(Location)
					end
					it "accepts commas" do
						post :create, {location: comma_attrs }, valid_session
						expect(response.status).to redirect_to(Location.last)
					end
					it "creates it with valid values" do
						post :create, {location: comma_attrs }, valid_session
						expect(Location.last.latitude).to eq(43.21)
					end
				end
			end

			describe "PUT update" do
				let(:location) { FactoryGirl.create(:location) }
				describe "with valid params" do
					it "updates the requested location" do
						# Assuming there are no other locations in the database, this
						# specifies that the Location created on the previous line
						# receives the :update_attributes message with whatever params are
						# submitted in the request.
						expect_any_instance_of(Location).to receive(:update).with({ "name" => "MyString" })
						put :update, {:id => location.to_param, :location => { "name" => "MyString" }}, valid_session
					end

					it "assigns the requested location as @location" do
						put :update, {:id => location.to_param, :location => valid_attributes}, valid_session
						expect(assigns(:location)).to eq(location)
					end

					it "redirects to the location" do
						put :update, {:id => location.to_param, :location => valid_attributes}, valid_session
						expect(response).to redirect_to(locations_path)
					end
				end

				describe "with invalid params" do
					it "assigns the location as @location" do
						# Trigger the behavior that occurs when invalid params are submitted
						allow_any_instance_of(Location).to receive(:save).and_return(false)
						put :update, {:id => location.to_param, :location => { "name" => "invalid value" }}, valid_session
						expect(assigns(:location)).to eq(location)
					end

					it "re-renders the 'edit' template" do
						# Trigger the behavior that occurs when invalid params are submitted
						allow_any_instance_of(Location).to receive(:save).and_return(false)
						put :update, {:id => location.to_param, :location => { "name" => "invalid value" }}, valid_session
						expect(response).to render_template("edit")
					end
				end
				describe "with ,s instead of .s for decimal points" do
					before {
						location.latitude = 41.12345
						location.save
						@initial_value = 41.12345
					}
					it "updates the information" do
						put :update, {:id => location.to_param, :location => { :latitude => "41,654321" }}, valid_session
						new_location = Location.find(location.id)
						expect(new_location.latitude).not_to eq(@initial_value)
					end
					it "accepts commas" do
						put :update, {:id => location.to_param, :location => { :latitude => "41,654321" }}, valid_session
						new_location = Location.find(location.id)
						expect(new_location.latitude).to eq(41.654321)
					end
				end
			end

			describe "DELETE destroy" do
			before { @location = FactoryGirl.create(:location) }
			
			it "destroys the requested location" do
				expect {
					delete :destroy, {id: @location.to_param}, valid_session
				}.to change(Location, :count).by(-1)
			end

			it "redirects to the locations list" do
				delete :destroy, {id: @location.to_param}, valid_session
				expect(response).to redirect_to(locations_url)
			end
		end
		end
		
		describe "as normal user" do
			let(:location) { FactoryGirl.create(:location, location_type: "hospital") }
			let(:user) { FactoryGirl.create(:user) }
			before do
				sign_in user
				location.save
			end
			
			describe "as JSON" do
				describe "index" do
					before { get :index, { format: :json } }
					it "status is correct" do
						expect(response.status).to eq(200)
					end
					it "has the json header" do
						expect(response.header["Content-Type"]).to include("application/json")
					end
					it "assigns the locations to @locations" do
						expect(assigns(:locations)).to eq(user.map_elements)
					end
				end
			end
			
			describe "as web" do
				describe "GET index" do
					it "assigns all locations as @locations" do
						get :index, {}, valid_session
						expect(response.status).to eq(302)
					end
				end
				describe "GET map" do
					let(:location1) { FactoryGirl.create(:location) }
					it "shows the map" do
						get :map
						expect(response.status).to eq(200)
					end
				end
				describe "GET show" do
					it "does not assign the location" do
						get :show, {id: location.id}, valid_session
						expect(assigns(:location)).not_to eq(location)
					end
					it "redirects to map" do
						get :show, {id: location.id}, valid_session
						expect(response).to redirect_to(root_url)
					end
				end
			end
		end
	end
end
