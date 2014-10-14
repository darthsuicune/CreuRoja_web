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

describe UsersController do

	# This should return the minimal set of attributes required to create a valid
	# User. As you add validations to User, be sure to
	# adjust the attributes here as well.
	let(:valid_attributes) { { "name" => "MyString", "surname" => "MyString2",
										"email" => "email1@something.com", "assemblies" => { "assembly_id" => 1 } } }
	
	let(:full_attributes) { { "name" => "MyString", 
										"surname" => "MyString2",
										"email" => "email1@something.com", 
										"phone" => "13470198723",
										"resettoken" => "123öjipouhn09819832r190832",
										"resettime" => Time.now,
										"language" => "ca",
										"role" => "volunteer",
										"active" => true,
										"password" => "MyPass", 
										"password_confirmation" => "MyPass", 
										"assemblies" => { "assembly_id" => 1 } } }
	
	let(:user_types) { { "name" => "MyString", 
										"surname" => "MyString2",
										"email" => "email1@something.com", 
										"phone" => "13470198723",
										"resettoken" => "123öjipouhn09819832r190832",
										"resettime" => Time.now,
										"language" => "ca",
										"role" => "volunteer",
										"active" => true,
										"password" => "MyPass", 
										"password_confirmation" => "MyPass", 
										"assemblies" => { "assembly_id" => 1 },
										"user_types_attributes" => { "0" => { "user_types" => "type1" } } } 
							}

	# This should return the minimal set of values that should be in the session
	# in order to pass any filters (e.g. authentication) defined in
	# UsersController. Be sure to keep this updated too.
	let(:valid_session) { {} }

	let(:user) { FactoryGirl.create(:user) }
	let(:tech) { FactoryGirl.create(:tech) }
	let(:assembly) { FactoryGirl.create(:assembly) }
	before do
		tech.save
		tech.user_assemblies.create(assembly_id: assembly.id)
		sign_in tech
	end

	describe "GET index" do
		let(:assembly) { FactoryGirl.create(:assembly) }
		let(:user1) { FactoryGirl.create(:user) }
		let(:user2) { FactoryGirl.create(:user) }
		before do
			UserAssembly.create(assembly_id: assembly.id, user_id: user.id)
			UserAssembly.create(assembly_id: assembly.id, user_id: user1.id)
		end
		describe "for admins" do
			before do
				tech.role = "admin"
				tech.save
			end
			
			it "assigns all users as @users" do
				get :index
				expect(assigns(:users)).to match_array([user, tech, user1, user2])
			end
			
			after do
				tech.role = "technician"
				tech.save
			end
		end
		describe "for technicians" do
			it "only assigns the users from the same assembly" do
				get :index
				expect(assigns(:users)).to match_array([tech,user,user1])
			end
		end
		
		describe "for other users" do
			it "only assigns the users from the same assembly" do
				get :index
				expect(assigns(:users)).to match_array([tech,user,user1])
			end
		end
		
	end

	describe "GET show" do
		describe "existing user" do
			before { get :show, {:id => user.to_param}, valid_session }
			it "assigns the requested user as @user" do
				expect(assigns(:user)).to eq(user)
			end
		end
		describe "non-existing user" do
			it "redirects to user list" do
				expect { 
					get :show, {:id => 555 }, valid_session 
				}.to raise_error(ActiveRecord::RecordNotFound)
			end
		end
	end

	describe "GET new" do
		it "assigns a new user as @user" do
			get :new, {}, valid_session
			expect(assigns(:user)).to be_a_new(User)
		end
	end

	describe "GET edit" do
		it "assigns the requested user as @user" do
			get :edit, {:id => user.to_param}, valid_session
			expect(assigns(:user)).to eq(user)
		end
	end

	describe "POST create" do
		describe "with valid params" do
			it "creates a new User" do
				expect {
					post :create, { :user => valid_attributes }, valid_session
				}.to change(User, :count).by(1)
				expect(User.last.password_digest).not_to be_nil
			end
			
			it "creates a full user" do
				expect {
					post :create, { :user => full_attributes }, valid_session
				}.to change(User, :count).by(1)
			end

			it "assigns a newly created user as @user" do
				post :create, { :user => valid_attributes }, valid_session
				expect(assigns(:user)).to be_a(User)
				expect(assigns(:user)).to be_persisted
			end

			it "redirects to the created user" do
				post :create, { :user => valid_attributes }, valid_session
				expect(response).to redirect_to(users_path)
			end
			
			it "assigns the user the creator assembly" do
				expect {
					post :create, { :user => valid_attributes }, valid_session
				}.to change(UserAssembly, :count).by(1)
			end
		end

		describe "with invalid params" do
			it "assigns a newly created but unsaved user as @user" do
				# Trigger the behavior that occurs when invalid params are submitted
				expect_any_instance_of(User).to receive(:save).and_return(false)
				post :create, {:user => { "name" => "invalid value" * 6 }}, valid_session
				expect(assigns(:user)).to be_a_new(User)
			end

			it "re-renders the 'new' template" do
				# Trigger the behavior that occurs when invalid params are submitted
				expect_any_instance_of(User).to receive(:save).and_return(false)
				post :create, {:user => { "name" => "invalid value" * 6 }}, valid_session
				expect(response).to render_template("new")
			end
	end
	end

	describe "PUT update" do
		describe "with valid params" do
			it "updates the requested user" do
				# Assuming there are no other users in the database, this
				# specifies that the User created on the previous line
				# receives the :update_attributes message with whatever params are
				# submitted in the request.
				expect_any_instance_of(User).to receive(:update).with({ "name" => "MyString" })
				put :update, {:id => user.to_param, :user => { "name" => "MyString" }}
			end

			it "assigns the requested user as @user" do
				put :update, {:id => user.to_param, :user => valid_attributes}
				expect(assigns(:user)).to eq(user)
			end

			it "redirects to the user" do
				put :update, {:id => user.to_param, :user => valid_attributes}
				expect(response).to redirect_to(user)
			end
			
			describe "deactivating the user" do
				before do
					user.save 
					user.create_session_token
				end
				it "destroys its sessions" do
					expect { 
						put :update, {id: user.to_param, :user => { active: false } }
					}.to change(Session, :count).by(-1)
				end
			end
		end

		describe "with invalid params" do
			before do
				allow_any_instance_of(User).to receive(:save).and_return(false)
				put :update, {:id => user.to_param, :user => { :name => "invalid value"*60 }}, valid_session
			end
			it "assigns the user as @user" do
				# Trigger the behavior that occurs when invalid params are submitted
				expect(assigns(:user)).to eq(user)
			end

			it "re-renders the 'edit' template" do
				# Trigger the behavior that occurs when invalid params are submitted
				expect(response).to render_template("edit")
			end
		end
	end

	describe "DELETE destroy" do
		before { @user = FactoryGirl.create(:user) }
		it "destroys the requested user" do
			expect { 
				delete :destroy, {:id => @user.to_param}, valid_session 
			}.to change(User, :count).by(-1)
		end

		it "redirects to the users list" do
			delete :destroy, {:id => @user.to_param}, valid_session 
			expect(response).to redirect_to(users_url)
		end
	end
end
